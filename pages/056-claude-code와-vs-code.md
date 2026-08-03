## 056. Claude Code와 VS Code

난이도: 중급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Claude Code는 터미널에서 동작하지만 VS Code와 함께 쓰면 더 편합니다. 공식 IDE 통합은 터미널 실행에 더해 IDE diff viewer, 선택 영역 공유, 파일 참조 단축키, 진단 오류 공유를 제공합니다.

VS Code에서 중요한 원칙은 간단합니다. Claude Code는 “작업 실행자”, VS Code는 “검토와 탐색 화면”으로 나누어 쓰는 것입니다.

### 시작 방법

VS Code의 통합 터미널에서 프로젝트 루트로 이동한 뒤 실행합니다.

```text
claude
```

VS Code 계열 IDE에서는 통합 터미널에서 `claude`를 실행하면 확장이 자동 설치될 수 있습니다. 외부 터미널에서 이미 Claude Code를 실행 중이라면 `/ide`로 IDE에 연결할 수 있습니다.

```text
/ide
```

diff 도구는 `/config`에서 설정합니다.

```text
/config
```

diff tool을 `auto`로 두면 IDE 감지를 사용할 수 있습니다.

### VS Code에서 유용한 기능

| 기능 | 쓰임 |
| --- | --- |
| IDE diff viewer | 터미널 diff보다 변경 검토가 쉽다 |
| selection context | 현재 선택한 코드나 열린 탭 맥락을 Claude가 참고한다 |
| diagnostics sharing | TypeScript, lint, syntax 오류를 Claude가 참고한다 |
| file reference shortcut | 파일과 라인 범위를 프롬프트에 빠르게 넣는다 |
| quick launch | 에디터에서 Claude Code를 빠르게 연다 |

파일 참조는 다음처럼 명시적으로 써도 됩니다.

```text
@src/components/UserCard.tsx 를 기준으로 접근성 문제를 검토해줘.
아직 파일은 수정하지 마.
```

### 좋은 작업 흐름

1. VS Code에서 관련 파일을 연다.
2. Claude Code에 읽기 전용 분석을 요청한다.
3. 계획을 검토한다.
4. 작은 범위만 구현하게 한다.
5. VS Code diff viewer로 변경사항을 확인한다.
6. 테스트를 실행하고 결과를 요약하게 한다.

### VS Code용 프롬프트

```text
현재 VS Code에서 열어둔 파일과 선택 영역을 중심으로 분석해줘.

목표:
[수정하거나 이해하려는 목표]

제약:
- 아직 파일은 수정하지 마.
- 관련 파일을 더 읽어야 하면 먼저 이유를 설명해줘.
- 변경 계획, 위험, 테스트 방법을 작성해줘.
```

구현 승인:

```text
좋아. 지금 연 파일과 직접 관련된 범위만 수정해줘.

제약:
- 관련 없는 포맷 변경은 하지 마.
- 수정 후 변경 파일을 요약해줘.
- VS Code diff에서 확인할 포인트를 알려줘.
```

### 문제 해결

VS Code 확장이 동작하지 않으면 다음을 확인합니다.

- VS Code 통합 터미널에서 `claude`를 실행했는가
- `code` 명령이 PATH에 있는가
- 프로젝트 루트에서 실행했는가
- `/config`의 diff 설정이 적절한가
- VS Code가 확장 설치 권한을 가지고 있는가

### 체크리스트

- [ ] 프로젝트 루트의 VS Code 터미널에서 `claude`를 실행한다.
- [ ] 외부 터미널 사용 시 `/ide`로 연결한다.
- [ ] diff viewer를 IDE로 확인한다.
- [ ] 선택 영역을 근거로 요청하되, 필요한 파일은 추가로 읽게 한다.
- [ ] 수정 후 테스트와 diff 검토를 함께 한다.

### 다음 단계

다음 장에서는 JetBrains IDE에서 Claude Code를 사용할 때 설정과 주의사항을 다룹니다.
