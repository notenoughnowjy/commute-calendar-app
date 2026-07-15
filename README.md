# 근태 관리 달력 (Commute Calendar)

자율 출퇴근제 환경에서 **월 필요 출근 시간**을 관리하고, 매일의 출퇴근 기록을 통해 **잔여 출근 시간**을 자동 계산하는 Flutter 앱입니다.

- 하루 9시간 기준으로 한 달 동안의 출퇴근 기록을 관리
- 공휴일(음력 포함)·휴가(연차/반차/반반차)를 제외한 월 필요 시간 자동 계산
- iOS / Android / macOS / Windows 지원 반응형 UI

자세한 기획·설계는 [`docs/PRD.md`](docs/PRD.md), [`docs/SPEC.md`](docs/SPEC.md), [`docs/PLAN.md`](docs/PLAN.md)를 참고하세요.

---

## 기술 스택

| 계층 | 기술 |
|------|------|
| Framework | Flutter 3.44.x / Dart 3.11.x |
| 상태 관리 | flutter_bloc (BLoC 기반 Clean Architecture) |
| 의존성 주입 | GetIt |
| 로컬 DB | Drift (SQLite ORM) |
| 라우팅 | go_router |
| 캘린더 UI | table_calendar |
| 공휴일 | world_holidays |
| 아이콘 | phosphor_flutter (로컬 patched 사본) |

> 현재 버전은 **로컬 저장(Drift)** 기반으로만 동작하며, 외부 서버·API 키 등 별도의 환경변수 설정이 필요 없습니다.

---

## 프로젝트 설정

### 1. 사전 준비

- **Flutter SDK 3.44.2 이상** (Dart 3.11.5 이상)
- Android 빌드: **JDK 17**, Android Studio / Android SDK
- iOS 빌드(macOS 전용): **Xcode**, CocoaPods

설치 상태 확인:

```bash
flutter --version
flutter doctor
```

### 2. 저장소 클론

```bash
git clone https://github.com/notenoughnowjy/commute-calendar-app.git
cd commute-calendar-app
```

### 3. 의존성 설치

```bash
flutter pub get
```

> `phosphor_flutter`는 Flutter 3.43+ 의 final-class IconData 호환을 위해 `packages/phosphor_flutter/` 로컬 사본을 `dependency_overrides`로 사용합니다. 별도 설치 없이 클론된 상태 그대로 동작합니다.

### 4. 코드 생성 (Drift DB)

`lib/core/database/` 의 DB 스키마를 수정한 경우 아래 명령으로 생성 코드를 다시 만들어야 합니다.

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. 실행

```bash
flutter run                 # 연결된 기기/시뮬레이터에서 디버그 실행
flutter run -d macos        # macOS 데스크톱 실행
flutter run -d windows      # Windows 데스크톱 실행
```

### 6. 정적 분석 (작업 후 권장)

```bash
flutter analyze
dart fix --apply
```

---

## Android 설치 (APK)

### APK 빌드

```bash
flutter build apk --release
```

빌드가 완료되면 결과물은 다음 경로에 생성됩니다.

```
build/app/outputs/flutter-apk/app-release.apk
```

> 기기 아키텍처별로 용량을 줄이려면 `--split-per-abi` 옵션을 사용할 수 있습니다.
> ```bash
> flutter build apk --release --split-per-abi
> ```
> `app-arm64-v8a-release.apk`(대부분의 최신 기기) 등이 생성됩니다.

> ⚠️ 현재 release 빌드는 debug 키로 서명되어 있어 **사이드로딩/테스트용**으로 적합합니다. Google Play 배포 시에는 `android/app/build.gradle.kts`에 별도의 release 서명 설정이 필요합니다.

### 기기에 설치

**방법 A — 파일 직접 설치**
1. `app-release.apk` 파일을 기기로 전송 (USB, 메신저, 클라우드 등)
2. 기기에서 파일 실행 → "출처를 알 수 없는 앱 설치 허용"을 켜고 설치

**방법 B — adb로 설치 (USB 디버깅 필요)**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

**방법 C — 연결된 기기에 바로 빌드·설치**
```bash
flutter install
```

---

## iOS 설치

> iOS는 APK가 아니라 **IPA** 형식을 사용하며, Apple 서명(개발자 계정)이 필요합니다.

### 방법 A — Xcode에서 기기에 직접 설치 (가장 간단)

1. 기기를 Mac에 연결
2. 프로젝트 열기
   ```bash
   open ios/Runner.xcworkspace
   ```
3. Xcode 상단에서 실행 대상 기기 선택
4. **Signing & Capabilities** 탭에서 본인의 Apple 개발 팀(Team) 지정
5. ▶︎(Run) 버튼으로 빌드 및 설치

또는 CLI로:

```bash
flutter run --release   # 연결된 iOS 기기 선택 후 설치 실행
```

### 방법 B — IPA 빌드 후 배포

```bash
flutter build ipa --release
```

빌드 결과:

```
build/ios/ipa/*.ipa
```

생성된 IPA는 배포 방식에 따라 설치합니다.
- **Ad Hoc**: 등록된 기기 UDID 대상으로 Apple Configurator / 배포 서비스로 설치
- **App Store / TestFlight**: `open build/ios/archive/Runner.xcarchive` 후 Xcode Organizer에서 업로드

> iOS는 무료 Apple ID로도 개발용 기기 설치가 가능하나 서명 유효기간(7일) 제한이 있습니다. 정식 배포·장기 설치에는 유료 Apple Developer Program 가입이 필요합니다.

---

## 프로젝트 구조

```
lib/
├── core/                 # 공통 계층
│   ├── constants/        # 상수
│   ├── database/         # Drift DB (app_database.dart)
│   ├── di/               # GetIt 서비스 로케이터 (service_locator.dart)
│   ├── error/            # 에러 처리
│   ├── network/          # 네트워크
│   ├── router/           # go_router 라우팅 (app_router.dart)
│   ├── services/         # 서비스
│   ├── theme/            # 테마
│   └── utils/            # 유틸리티
└── feature/
    ├── calendar/         # 근태 달력 기능 (data / domain / presentation)
    └── common/           # 공통 위젯
```

레이어 규칙, 네이밍 컨벤션 등 상세 개발 가이드는 [`CLAUDE.md`](CLAUDE.md)를 참고하세요.
