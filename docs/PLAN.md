# UI 최종 수정사항 — 구현 계획서

## 프로젝트 현황

프로토타입 수준으로 구현된 UI에 섬세함을 더하고, 누적된 UX 결함·overflow·로직 버그를 정리하는 작업이다.
신규 기능 추가는 없으며, **기존 화면의 다듬기·버그 수정·리팩토링·컴포넌트화**가 핵심이다.

> SPEC의 `모델링`/`supabase 세팅`/`Data 레이어`/`도메인 레이어` 섹션은 비어 있으며,
> 이미 구현 완료된 영역으로 간주한다. 본 계획은 **UI 영역만** 다룬다.

---

## 결정 사항

| 항목 | 결정 |
|------|------|
| 작업 범위 | UI 다듬기 · 버그 수정 · 리팩토링 · 컴포넌트화 (데이터/도메인 레이어 변경 없음) |
| 진행 순서 | 공통 기반(ThemeService) → 화면별 수정 → 전역 UX → 리팩토링/컴포넌트화 → 엣지케이스 |
| 디자인 원칙 | 기존 `ThemeService` 색상·텍스트 스타일 **반드시 준수**, 단순·가독성 우선, Material 위젯 지양 |
| 아이콘 | `PhosphorIcon`만 사용 (기존 규칙 유지) |
| 상태 관리 | UI 코드의 로직은 가능한 한 BLoC으로 이관 (event/state 확장) |

> **규칙**: Phase 순서 엄수. 각 Phase 완료 후 `flutter analyze` + `dart fix --apply` 통과 확인.
> 사용자 지시 없이 커밋하지 않음. 주석은 명시적 요청 없이는 삭제하지 않음.
> **사용자가 지시한 Phase만 진행**하고, 다음 Phase는 별도 지시 전까지 시작하지 않는다.

---

## Phase 개요 & 의존성

```
Phase 0 (ThemeService 기반)
    └─> Phase 1 (CalendarPage/Widget)
    └─> Phase 2 (DayInfoWidget)
    └─> Phase 3 (WorkRecordBottomSheet)
            └─> Phase 4 (전역 UX 개선)
                    └─> Phase 5 (리팩토링 & 컴포넌트화)
                            └─> Phase 6 (엣지/에러케이스 점검)
```

- Phase 0은 텍스트 스타일 전반에 영향을 주므로 **가장 먼저** 수행한다.
- Phase 1~3은 Phase 0 이후 독립적으로 진행 가능(서로 의존 없음).
- Phase 5(리팩토링)는 화면별 수정(1~3)이 끝난 뒤 안정된 상태에서 진행한다.

---

## Phase 0 — ThemeService fontWeight 체계 정리

### 개요
각 타이포마다 `FontWeight.w600`을 직접 박아넣던 방식을 제거하고,
ThemeService에 `semiBold` / `regular` / `light` 세 가지 weight 상수를 선언해 각 타이포에 주입한다.
외부에서도 `copyWith`로 weight를 가져다 쓸 수 있도록 공개한다.

### 핵심 작업
- `ThemeService`에 weight 상수 3종 선언
  - `static const FontWeight semiBold = FontWeight.w600;`
  - `static const FontWeight regular = FontWeight.w400;`
  - `static const FontWeight light = FontWeight.w300;`
- 기존 텍스트 스타일(`headline`/`subtitle`/`body1`/`body2`/`caption`/`timeDisplay`)의 `fontWeight`를 위 상수로 치환
- 코드 곳곳의 `FontWeight.w600` 등 하드코딩을 `ThemeService.semiBold` 형태로 점진 치환

### 대상 파일
- `lib/core/theme/theme_service.dart` (선언 및 적용)
- weight를 하드코딩한 위젯들 (치환 대상 검색 후 정리)

### 완료 체크리스트
- [x] weight 상수 3종 선언 완료
- [x] 기존 텍스트 스타일이 상수를 참조하도록 변경
- [x] 하드코딩된 `FontWeight.wXXX` 치환 (외부에서 copyWith로 weight 적용 가능 확인)
- [x] `flutter analyze` 통과

---

## Phase 1 — CalendarPage / CalendarWidget 다듬기

### 개요
달력 화면의 헤더 스크롤 동작, 셀 레이아웃, overflow, dot 배치, 선택일 버그를 정리한다.

### 핵심 작업
1. **월 헤더 스크롤 연동**
   - 현재 `_PrimaryAppBar` + `_MonthHeader`가 `SingleChildScrollView` 바깥 `Column`에 고정됨
   - `_MonthHeader`(`yyyy년 M월`)를 스크롤 영역 안으로 이동해 콘텐츠와 함께 내려가게 함
   - (`_PrimaryAppBar`의 고정 여부는 작업 중 시각 확인 후 결정)
2. **셀 날짜 크기 축소**
   - `_buildDateCircle`의 날짜 텍스트 크기를 줄임 (`body2` → 더 작은 스케일 또는 copyWith)
3. **근무시간 라벨 overflow 해결**
   - `10h 20m`처럼 긴 라벨이 셀 폭을 넘는 문제
   - `_formatDuration` 표기 간소화(`h`/`m` 제거 등) 또는 `FittedBox`/축약 표기 적용
4. **dot + 근무시간 동시 표시 시 세로 배치**
   - 현재 `_buildCellLabel`에서 둘 다 있으면 `Row`로 나란히 배치 → `Column`으로 변경
   - dot을 위에, 근무시간을 아래에 배치
5. **근태 삭제/기록 시 selectedDate가 오늘로 초기화되는 버그**
   - 기록 저장·삭제 후 상태 재생성 과정에서 `selectedDate`가 보존되지 않는 원인 추적
   - `CalendarBloc`에서 기존 `selectedDate`를 유지하도록 수정

### 대상 파일
- `lib/feature/calendar/presentation/pages/calendar_page.dart`
- `lib/feature/calendar/presentation/widgets/calendar_widget.dart`
- `lib/feature/calendar/presentation/bloc/calendar_bloc.dart` (selectedDate 보존)

### 완료 체크리스트
- [x] 월 헤더가 스크롤과 함께 이동
- [x] 셀 날짜 크기 축소 적용
- [x] 긴 근무시간 라벨 overflow 해소
- [x] dot/근무시간 세로 배치 (dot 위, 시간 아래)
- [x] 근태 기록·삭제 후 selectedDate 유지 확인
- [x] `flutter analyze` 통과

---

## Phase 2 — DayInfoWidget (InfoPage) 다듬기

### 개요
선택일 상세 카드의 디테일을 정리한다.

### 핵심 작업
1. **근태 Card 앞 primary 강조 바 크기 조정**
   - 카드 좌측 primary 색상 얇은 container가 너무 작음 → 약간 키움
2. **공휴일 이름 빨간색 표기 제거**
   - 날짜 밑에 공휴일명이 `secondary`(빨강)로 뜨는 부분 삭제

### 대상 파일
- `lib/feature/calendar/presentation/widgets/day_info_widget.dart`

### 완료 체크리스트
- [x] 강조 바 크기 자연스럽게 조정
- [x] 공휴일명 빨간 텍스트 제거
- [x] 디자인 시스템 색상/스타일 준수 확인
- [x] `flutter analyze` 통과

---

## Phase 3 — WorkRecordBottomSheet 입력 UX 수정

### 개요
근무시간 입력 시 키보드·피커 관련 UX 결함을 해결한다.

### 핵심 작업
1. **시간/분 TextField 전환 시 키보드 깜빡임 제거**
   - 옆 TextField를 누르면 키보드가 잠깐 내려갔다 올라오는 현상
   - `FocusNode` 명시 관리 또는 포커스 전환 방식 개선으로 키보드 유지
2. **키보드 올라온 채 CupertinoPicker 표출 시 overflow 해결**
   - 출퇴근 시간 피커(`WorkRecordCommutePicker`) 펼칠 때 `viewInsets`와 겹쳐 overflow
   - 피커 표출 전 키보드 dismiss, 또는 레이아웃이 viewInsets를 고려하도록 수정

### 대상 파일
- `lib/feature/calendar/presentation/widgets/work_record_bottom_sheet.dart`
- `lib/feature/calendar/presentation/widgets/work_record_commute_picker.dart`

### 완료 체크리스트
- [ ] 시간↔분 전환 시 키보드 유지 (깜빡임 없음)
- [ ] 키보드 상태에서 피커 표출해도 overflow 없음
- [ ] `flutter analyze` 통과

---

## Phase 4 — 전역 UX 개선

### 개요
화면 전반에 걸친 공통 UX 결함을 정리한다.

### 핵심 작업
1. **키보드 dismiss 수단 제공**
   - 특근현황 등 입력 화면에서 키보드를 내릴 방법이 없음
   - 화면 빈 영역 탭 시 `FocusScope.unfocus()` 처리 (공통 래퍼 위젯 검토)
2. **앱바 버튼 hit 범위·인식률 개선**
   - `_MonthHeader`의 caret 버튼, `_PrimaryAppBar` 아이콘 등 `GestureDetector` 히트 영역이 좁음
   - `HitTestBehavior.opaque` 적용 또는 충분한 터치 타깃(최소 44px) 확보
3. **overflow 전반 점검**
   - 각 화면을 훑으며 좁은 화면/긴 텍스트에서의 overflow를 일괄 처리

### 대상 파일
- 공통 래퍼: `lib/feature/common/widgets/` (필요 시 신규 위젯)
- `lib/feature/calendar/presentation/pages/calendar_page.dart` (앱바 히트 영역)
- 입력이 있는 페이지 전반 (특근현황 등)

### 완료 체크리스트
- [x] 입력 화면에서 빈 영역 탭으로 키보드 dismiss 가능
- [x] 앱바/네비 버튼 터치 인식률 개선
- [x] 주요 화면 overflow 없음 확인
- [x] `flutter analyze` 통과

---

## Phase 5 — 리팩토링 & 컴포넌트화

### 개요
복잡해진 UI 코드를 feature별로 page부터 차근차근 정리한다. 거시적으로 한 번에 보지 않고,
**feature 단위로 page → widget 순서로** 훑으며 진행한다.

### 핵심 작업
1. **BLoC 이관**
   - 위젯 내부의 계산·분기 로직 중 BLoC으로 옮길 수 있는 것은 event/state로 이관
2. **불필요한 변수·복잡 구현 정리**
   - 중복 선언, 과도하게 복잡한 위젯 트리 단순화
3. **컴포넌트화**
   - 반복되는 UI 패턴(예: 핸들/타이틀/저장 버튼/시간 입력 필드 등)을 공통 위젯으로 추출
4. **파일 크기 점검**
   - 400줄 초과 파일 분리

### 대상 파일
- `lib/feature/calendar/presentation/` 전반 (page → widget 순)
- 추출된 공통 컴포넌트: `lib/feature/common/widgets/`

### 완료 체크리스트
- [x] 위젯에서 분리 가능한 로직을 BLoC으로 이관
- [x] 중복/복잡 코드 정리
- [x] 반복 UI 컴포넌트화 완료
- [x] 모든 파일 400줄 이하 유지
- [x] 기존 동작 회귀 없음 확인
- [x] `flutter analyze` 통과

---

## Phase 5.5 — 시간/날짜 유틸 함수 통합 ✅

`lib/core/utils/`에 `DurationFormatter`, `DateFormatter` 생성.
프레젠테이션 레이어 10개 파일의 중복 함수 제거 및 교체 완료.

---

## Phase 6 — 엣지/에러케이스 점검

### 개요
엣지케이스와 에러케이스를 잘 잡도록 마무리 점검한다.

### 핵심 작업
- 빈 입력·비정상 값(시간 0, 분 60 이상 등) 처리 확인
- 네트워크/저장 실패 시 사용자 친화적 에러 메시지 노출 확인
- null 안전성(`?`/`??`/`!`) 신중 사용 점검

### 대상 파일
- 입력·저장 흐름 전반 (bottom sheet, BLoC, repository 경계)

### 완료 체크리스트
- [ ] 주요 입력 엣지케이스 처리 확인
- [ ] 에러 메시지 사용자 관점에서 이해 가능
- [ ] null 안전성 점검 완료
- [ ] `flutter analyze` 통과

---

## 작업 시 공통 준수 사항

- 모든 구현은 **단순하고 가독성 좋게**. 화려함보다 명확함.
- 기존 **디자인 시스템·테마 반드시 준수** (색상/타이포는 `ThemeService` 경유).
- 아이콘은 **PhosphorIcon만** 사용.
- 함수 순서는 상위(호출자) → 하위(피호출자).
- 각 Phase는 의미 있는 단위로 커밋(단, 사용자 지시 후에만).
