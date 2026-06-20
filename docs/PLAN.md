# 연장근무·휴일근무(특근) 기능 추가 — 구현 계획서

## 프로젝트 현황

현재 `WorkRecordEntity`는 `work`, `vacation`, `holiday` 세 가지 타입을 지원하며,
달력 1일 1 레코드 구조(`Map<DateTime, WorkRecordEntity>`)로 운용 중이다.

SPEC에서 요구하는 특근 기능을 추가하려면 다음 변경이 필요하다.
- 같은 날 일반근무 + 특근이 공존할 수 있어야 함 → 별도 엔티티·테이블 분리
- 특근은 일반 근무시간 계산(`CalculateMonthlyStatsUseCase`)에서 제외
- 수당 계산: 통상시급을 특근 현황 화면에서 직접 입력, 로컬 저장

---

## 결정 사항

| 항목 | 결정 |
|------|------|
| Feature 배치 | `calendar` feature 내 유지 (달력 표시와 긴밀히 연결) |
| 데이터 모델 | 별도 `OvertimeRecordEntity` 신규 생성 (WorkRecordEntity 변경 없음) |
| 수당 계산 | 통상시급 직접 입력 (특근 현황 화면), `SharedPreferences`에 로컬 저장 |
| 특근 색상 | `ThemeService.tertiary` (크림, 기존 미사용 색상) 활용 |
| 특근 현황 화면 진입 | CalendarPage AppBar에 아이콘 버튼 추가 |
| BLoC 전략 | CalendarBloc 확장 (overtime 관련 이벤트·상태 추가) |

> **규칙**: Phase 순서 엄수. 각 Phase 완료 후 `flutter analyze` 통과 확인. 사용자 지시 없이 커밋하지 않음.

---

## 핵심 설계

### OvertimeRecordEntity (신규)

```dart
enum OvertimeType {
  weekdayOvertime, // 연장근무 (평일 시간 외 근무)
  holidayWork,     // 휴일근무 (주말/공휴일 근무)
}

class OvertimeRecordEntity extends Equatable {
  final String id;
  final DateTime date;
  final OvertimeType type;
  final int workMinutes;  // 특근 시간 (분 단위, 필수)
  final String? memo;

  Duration get workedDuration => Duration(minutes: workMinutes);
}
```

### CalendarLoaded 상태 확장

```dart
// 기존: records: Map<DateTime, WorkRecordEntity>  (일반근무·연차·휴일, 날짜당 1개)
// 추가: overtimeRecords: Map<DateTime, List<OvertimeRecordEntity>>  (날짜당 여러 개 가능)
```

특근은 `CalculateMonthlyStatsUseCase`의 `totalRequired` / `totalWorked` 계산에 포함하지 않는다.

### DayInfoWidget 변경

- 기존: 날짜당 단일 `_RecordTile`
- 변경: 일반근무 카드(기존) + 특근 카드 목록(`_OvertimeTile` 신규) 순서로 List 표시
- 두 종류의 기록은 각각 독립적으로 삭제 가능

---

## Phase 1: 모델링 + DB 스키마

> **의존성**: 없음 (시작점)

### 핵심 작업

**`overtime_record_entity.dart`** (신규)
- `OvertimeType` enum (`weekdayOvertime`, `holidayWork`)
- `OvertimeRecordEntity`: id, date, type, workMinutes, memo
- `workedDuration` getter: `Duration(minutes: workMinutes)`
- `copyWith`, `props` 포함

**`overtime_record_model.dart`** (신규)
- `fromJson`: DB 컬럼 `id`, `date`, `type`, `work_minutes`, `memo` 파싱
- `toJson`: 직렬화 (user_id는 DataSource에서 주입)
- `fromEntity`: OvertimeRecordEntity → OvertimeRecordModel

**DB 스키마 (사용자가 Supabase 콘솔에서 직접 적용)**
```sql
CREATE TABLE overtime_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  date DATE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('weekdayOvertime', 'holidayWork')),
  work_minutes INTEGER NOT NULL,
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE overtime_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own overtime" ON overtime_records
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

### 파일 구조
```
lib/feature/calendar/domain/entities/
  overtime_record_entity.dart    (신규)
lib/feature/calendar/data/models/
  overtime_record_model.dart     (신규)
```

### 완료 체크리스트
- [x] `OvertimeType` enum 정의
- [x] `OvertimeRecordEntity` 작성 (id, date, type, workMinutes, memo, workedDuration, copyWith, props)
- [x] `OvertimeRecordModel` fromJson / toJson / fromEntity 작성
- [ ] Supabase `overtime_records` 테이블 생성 (사용자)
- [x] `flutter analyze` 통과

---

## Phase 2: 데이터 레이어

> **의존성**: Phase 1 완료 후 진행

### 핵심 작업

**`i_overtime_repository.dart`** (신규, 추상 인터페이스)
- `Future<List<OvertimeRecordEntity>> getOvertimeByMonth(int year, int month)`
- `Future<void> addOvertime(OvertimeRecordEntity record)`
- `Future<void> updateOvertime(OvertimeRecordEntity record)`
- `Future<void> deleteOvertime(String id)`

**`overtime_data_source.dart`** (신규)
- Supabase CRUD (try-catch 없음, Model 반환)
- insert 시 `user_id` 포함

**`overtime_repository_impl.dart`** (신규)
- DataSource 주입, try-catch로 예외 처리, Entity 반환

**`mock_overtime_repository.dart`** (신규)
- 목 데이터: weekdayOvertime 케이스, holidayWork 케이스 각각 포함
- 같은 날에 여러 특근 기록이 있는 케이스 포함

**`service_locator.dart`** (수정)
- `OvertimeDataSource`, `IOvertimeRepository` DI 등록

### 파일 구조
```
lib/feature/calendar/domain/repositories/
  i_overtime_repository.dart               (신규)
lib/feature/calendar/data/
  datasources/overtime_data_source.dart    (신규)
  repositories/overtime_repository_impl.dart (신규)
  repositories/mock_overtime_repository.dart (신규)
lib/core/di/
  service_locator.dart                     (수정)
```

### 완료 체크리스트
- [x] `IOvertimeRepository` 인터페이스 작성
- [x] `OvertimeDataSource` CRUD 구현 (user_id 포함)
- [x] `OvertimeRepositoryImpl` 구현 (예외 처리 포함)
- [x] `MockOvertimeRepository` 목 데이터 구현
- [x] 서비스 로케이터에 DataSource · Repository 등록
- [x] `flutter analyze` 통과

---

## Phase 3: 도메인 레이어 — UseCase

> **의존성**: Phase 2 완료 후 진행

### 핵심 작업

**신규 UseCase 파일 (4개)**
- `get_overtime_records_usecase.dart`: 월별 특근 조회
- `add_overtime_record_usecase.dart`: 특근 추가
- `update_overtime_record_usecase.dart`: 특근 수정
- `delete_overtime_record_usecase.dart`: 특근 삭제

**`calculate_overtime_stats_usecase.dart`** (신규)
- `OvertimeStats` 데이터 클래스:
  - `totalOvertimeMinutes`: 총 특근 시간 (분)
  - `weekdayOvertimeMinutes`: 연장근무 합계
  - `holidayWorkMinutes`: 휴일근무 합계
  - `calculateAllowance(int hourlyWage)`: 수당 금액 계산
    - 연장근무: `hourlyWage × 1.5 × (weekdayOvertimeMinutes / 60)`
    - 휴일근무: `hourlyWage × 2.0 × (holidayWorkMinutes / 60)`
- `call(int year, int month)` → `OvertimeStats`

**`service_locator.dart`** (수정)
- 5개 UseCase DI 등록

### 파일 구조
```
lib/feature/calendar/domain/usecases/
  get_overtime_records_usecase.dart          (신규)
  add_overtime_record_usecase.dart           (신규)
  update_overtime_record_usecase.dart        (신규)
  delete_overtime_record_usecase.dart        (신규)
  calculate_overtime_stats_usecase.dart      (신규, OvertimeStats 포함)
lib/core/di/
  service_locator.dart                       (수정)
```

### 완료 체크리스트
- [x] CRUD UseCase 4개 구현
- [x] `OvertimeStats` 데이터 클래스 정의
- [x] `CalculateOvertimeStatsUseCase` 구현 (수당 계산 포함)
- [x] DI 등록
- [x] `flutter analyze` 통과

---

## Phase 4: CalendarBloc 확장

> **의존성**: Phase 3 완료 후 진행

### 핵심 작업

**`calendar_state.dart`** (수정)
- `CalendarLoaded`에 `overtimeRecords: Map<DateTime, List<OvertimeRecordEntity>>` 추가
- `copyWith` 갱신

**`calendar_event.dart`** (수정)
- `CalendarOvertimeAdded(OvertimeRecordEntity record)` 추가
- `CalendarOvertimeUpdated(OvertimeRecordEntity record)` 추가
- `CalendarOvertimeDeleted(String id)` 추가

**`calendar_bloc.dart`** (수정)
- 생성자에 overtime UseCase 4개 추가
- `_loadMonth`에서 일반 records와 overtime records를 병렬로 조회
  - `overtimeList` → `Map<DateTime, List<OvertimeRecordEntity>>`로 변환
  - `CalendarLoaded` 생성 시 `overtimeRecords` 포함
- 핸들러 3개 추가: `_onOvertimeAdded`, `_onOvertimeUpdated`, `_onOvertimeDeleted`

### 파일 구조
```
lib/feature/calendar/presentation/bloc/
  calendar_state.dart    (수정)
  calendar_event.dart    (수정)
  calendar_bloc.dart     (수정)
```

### 완료 체크리스트
- [x] `CalendarLoaded`에 `overtimeRecords` 추가 및 `copyWith` 반영
- [x] Overtime 이벤트 3개 추가
- [x] `CalendarBloc` 생성자에 overtime UseCase 주입
- [x] `_loadMonth`에서 overtime 데이터 병렬 로드
- [x] overtime CRUD 핸들러 구현
- [x] `flutter analyze` 통과

---

## Phase 5: FAB & 특근 입력 UI

> **의존성**: Phase 4 완료 후 진행

### 핵심 작업

**`overtime_record_bottom_sheet.dart`** (신규)
- `OvertimeType` 선택 세그먼트 (연장근무 / 휴일근무)
- 시간(hour) / 분(minute) TextField (필수, 숫자만, `FilteringTextInputFormatter.digitsOnly`)
- 저장 시 `CalendarOvertimeAdded` / `CalendarOvertimeUpdated` 발행
- 0시간 0분 입력 방지 (저장 버튼 비활성)
- 편집 시 기존 값 복원

**`expandable_fab.dart`** (수정)
- "특근" 항목 추가 (아이콘: `PhosphorIcons.clock()`, 색상: `ThemeService.tertiary`)
- `_onOvertimeFabTapped(BuildContext)` → `OvertimeRecordBottomSheet.show()` 호출
- FAB 항목 순서: 근무 / 연차 / 휴일 / 특근

**`calendar_widget.dart`** (수정)
- 달력 셀에 특근 기록이 있는 날 `ThemeService.tertiary` 색상 점 표시
- 기존 work / vacation / holiday 표시 로직과 병렬로 처리

**`calendar_page.dart`** (수정)
- `_CalendarLegend`에 특근 색상 항목 추가

### 파일 구조
```
lib/feature/calendar/presentation/widgets/
  overtime_record_bottom_sheet.dart    (신규)
  calendar_widget.dart                 (수정)
lib/feature/common/widgets/
  expandable_fab.dart                  (수정)
lib/feature/calendar/presentation/pages/
  calendar_page.dart                   (수정: 범례)
```

### 완료 체크리스트
- [x] `OvertimeRecordBottomSheet` 구현 (타입 선택, 시간 입력, 저장)
- [x] FAB에 특근 항목 추가
- [x] 달력 셀에 특근 날짜 표시 추가
- [x] 범례에 특근 항목 추가
- [x] 편집(기존 기록 수정) 지원
- [x] 입력 검증 (미입력·범위 오류)
- [x] `flutter analyze` 통과

---

## Phase 6: DayInfoWidget — 일별 목록 표시

> **의존성**: Phase 5 완료 후 진행

### 핵심 작업

**`day_info_widget.dart`** (수정)
- `_DayInfoContent`에 `overtimeRecords: List<OvertimeRecordEntity>` 파라미터 추가
  - `CalendarLoaded.overtimeRecords[normalizedDate] ?? []`로 전달
- 렌더링 순서: 일반근무 카드(`_RecordTile`, 기존) → 특근 카드 목록(`_OvertimeTile`, 신규)
- 일반근무가 없어도 특근 카드는 표시 가능 (반대도 마찬가지)

**`_OvertimeTile` 신규 위젯** (`day_info_widget.dart` 하단)
- 색상 바: `ThemeService.tertiary`
- 타입 레이블: "연장근무" / "휴일근무"
- 아이콘: `PhosphorIcons.clock()`
- 특근 시간 강조 표시 (`body1`, `ThemeService.tertiary`)
- 메모 (있을 때만 caption으로)
- 삭제 버튼: `CalendarOvertimeDeleted` 이벤트 발행

### 파일 구조
```
lib/feature/calendar/presentation/widgets/
  day_info_widget.dart    (수정: overtimeRecords 파라미터, _OvertimeTile 추가)
```

### 완료 체크리스트
- [x] `_DayInfoContent`에서 overtime 파라미터 수신 및 렌더링
- [x] `OvertimeTile` 구현 (타입, 시간, 메모, 삭제)
- [x] 일반근무 없이 특근만 있는 날 정상 표시
- [x] 특근만 있는 날 `_EmptyRecordText` 표시 조건 정비
- [x] `flutter analyze` 통과

---

## Phase 7: 특근 현황·수당 계산 화면

> **의존성**: Phase 6 완료 후 진행

### 핵심 작업

**`overtime_summary_page.dart`** (신규)
- 진입: CalendarPage `_MonthHeader` AppBar 우측 아이콘 버튼 (`PhosphorIcons.clock()`)
- 월 선택 헤더 (좌우 이동, 현재 CalendarBloc의 focusedMonth 초기값)
- 통상시급 입력 필드 (숫자만, `SharedPreferences` 저장·복원)
- 특근 통계 요약 카드:
  - 연장근무: 총 시간, 예상 수당
  - 휴일근무: 총 시간, 예상 수당
  - 합계 수당
  - 시급 미입력 시 수당은 `- 원`으로 표시
- 특근 기록 목록: 날짜 / 타입 / 시간 / 메모 (날짜 오름차순)

**`app_router.dart`** (수정)
- `OvertimeSummaryPage` 라우트 추가

**`calendar_page.dart`** (수정)
- `_MonthHeader`에 AppBar 우측 아이콘 버튼 추가 → `OvertimeSummaryPage`로 이동

### 파일 구조
```
lib/feature/calendar/presentation/pages/
  overtime_summary_page.dart    (신규)
lib/core/router/
  app_router.dart               (수정)
lib/feature/calendar/presentation/pages/
  calendar_page.dart            (수정: 진입 버튼)
```

### 완료 체크리스트
- [x] 통상시급 입력 필드 + `SharedPreferences` 저장·복원
- [x] `CalculateOvertimeStatsUseCase` 연동 (월별 통계)
- [x] 연장근무 / 휴일근무 수당 별도 표시
- [x] 특근 기록 목록 (날짜 오름차순)
- [x] AppBar 진입 버튼 추가 (Navigator.push 방식, GoRouter 라우트 불필요)
- [x] `flutter analyze` 최종 통과

---

## 파일 전체 구조 (완료 후)

```
lib/
  core/
    di/service_locator.dart                                (수정)
    router/app_router.dart                                 (수정)
  feature/calendar/
    domain/
      entities/
        work_record_entity.dart                            (유지)
        overtime_record_entity.dart                        (신규)
      repositories/
        i_calendar_repository.dart                         (유지)
        i_overtime_repository.dart                         (신규)
      usecases/
        get_overtime_records_usecase.dart                  (신규)
        add_overtime_record_usecase.dart                   (신규)
        update_overtime_record_usecase.dart                (신규)
        delete_overtime_record_usecase.dart                (신규)
        calculate_overtime_stats_usecase.dart              (신규)
    data/
      models/
        work_record_model.dart                             (유지)
        overtime_record_model.dart                         (신규)
      datasources/
        work_record_data_source.dart                       (유지)
        overtime_data_source.dart                          (신규)
      repositories/
        calendar_repository_impl.dart                      (유지)
        overtime_repository_impl.dart                      (신규)
        mock_calendar_repository.dart                      (유지)
        mock_overtime_repository.dart                      (신규)
    presentation/
      bloc/
        calendar_bloc.dart                                 (수정)
        calendar_event.dart                                (수정)
        calendar_state.dart                                (수정)
      pages/
        calendar_page.dart                                 (수정)
        overtime_summary_page.dart                         (신규)
      widgets/
        calendar_widget.dart                               (수정)
        day_info_widget.dart                               (수정)
        overtime_record_bottom_sheet.dart                  (신규)
  feature/common/widgets/
    expandable_fab.dart                                    (수정)
```

DB: `overtime_records` 테이블 신규 생성 — 사용자가 Supabase 콘솔에서 적용.

---

## 참고사항
- **추상체는 Repo만**: `IOvertimeRepository` 신규 추가. DataSource는 추상체 없이 직접 구현.
- **특근은 근무시간 계산에서 제외**: `CalculateMonthlyStatsUseCase` 변경 없음.
- **디자인**: 기존 `ThemeService` 테마 준수. `PhosphorIcon`만 사용. Material 기본 위젯 지양.
- **단순함 우선**: 가독성 좋고 복잡하지 않게. 추상화 남용 금지.
- **파일 크기**: 400줄 초과 시 위젯 파일 분리.
- **커밋**: 사용자 명시적 지시 없이 커밋하지 않음.
- **작업 단위**: 사용자가 지시한 Phase만 진행. 다음 Phase는 명시적 지시까지 대기.
