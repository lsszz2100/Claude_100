## 057. Claude Code와 JetBrains

난이도: 중급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

JetBrains 계열 IDE에서도 Claude Code는 통합 터미널과 플러그인을 통해 사용할 수 있습니다. IntelliJ, PyCharm, WebStorm, Android Studio, GoLand 같은 IDE에서 코드 탐색, diff 검토, 진단 오류 공유를 함께 활용할 수 있습니다.

JetBrains에서는 프로젝트 루트, 터미널 설정, 플러그인 활성화 여부가 특히 중요합니다.

### 기본 실행

JetBrains IDE의 터미널에서 프로젝트 루트로 이동한 뒤 실행합니다.

```text
claude
```

외부 터미널에서 실행했다면 Claude Code 안에서 `/ide`를 사용해 IDE와 연결할 수 있습니다.

```text
/ide
```

설정은 `/config`와 JetBrains의 `Settings -> Tools -> Claude Code` 메뉴에서 조정할 수 있습니다.

### JetBrains에서 특히 유용한 상황

| 상황 | 이유 |
| --- | --- |
| 대형 Java/Kotlin 프로젝트 | IDE diagnostics와 타입 정보를 함께 보기 좋다 |
| Android Studio 프로젝트 | Gradle, Kotlin, 리소스 변경을 IDE에서 검토하기 좋다 |
| Python 프로젝트 | PyCharm의 import, venv, test runner 맥락과 함께 쓰기 좋다 |
| 복잡한 refactor | IDE diff와 검색 기능으로 검토하기 좋다 |

### JetBrains용 프롬프트

```text
JetBrains IDE에서 열린 현재 모듈을 기준으로 분석해줘.

목표:
[작업 목표]

제약:
- 아직 파일은 수정하지 마.
- 관련 Gradle/Maven/테스트 설정을 먼저 확인해줘.
- IDE diagnostics에 나온 오류가 있다면 원인 후보와 수정 계획을 분리해줘.
```

Android 프로젝트 예시:

```text
Android Studio 프로젝트에서 이 ViewModel 테스트 실패를 조사해줘.

확인할 것:
- 관련 ViewModel
- 테스트 파일
- Gradle test task
- coroutine 또는 lifecycle 관련 설정

아직 파일은 수정하지 마.
```

### ESC 키와 터미널 주의사항

JetBrains 터미널에서 ESC 키가 Claude Code 작업 중단으로 동작하지 않으면 IDE 터미널 설정을 확인해야 합니다. JetBrains 설정에서 ESC가 에디터 포커스 이동으로 잡혀 있으면 Claude Code 인터럽트와 충돌할 수 있습니다.

확인할 것:

- `Settings -> Tools -> Terminal`
- `Move focus to the editor with Escape` 설정
- 터미널 keybinding 충돌

### WSL 사용 시

Windows에서 WSL로 Claude Code를 실행한다면 JetBrains의 Claude command를 WSL 명령으로 지정할 수 있습니다.

```text
wsl -d Ubuntu -- bash -lic "claude"
```

배포판 이름은 실제 WSL 배포판에 맞게 바꿉니다.

### 체크리스트

- [ ] JetBrains 프로젝트 루트에서 Claude Code를 실행한다.
- [ ] 플러그인이 활성화되어 있는지 확인한다.
- [ ] 외부 터미널 사용 시 `/ide`를 연결한다.
- [ ] ESC 키 충돌이 있으면 터미널 설정을 조정한다.
- [ ] WSL 사용 시 Claude command 경로를 명확히 한다.

### 다음 단계

다음 장에서는 Claude Code Desktop을 시각적 검토와 여러 세션 운영에 활용하는 방법을 다룹니다.
