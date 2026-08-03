## 075. Hooks 개념

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Hooks는 Claude Code의 특정 순간에 자동 실행되는 사용자 정의 명령입니다. 프롬프트로 “항상 해줘”라고 부탁하는 대신, 설정 파일에 규칙을 등록해 실제 명령이 실행되게 만드는 방식입니다.

공식 문서 기준으로 Hooks는 `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Notification`, `Stop`, `SubagentStop`, `PreCompact`, `SessionStart`, `SessionEnd` 같은 이벤트에 연결할 수 있습니다.

### Hooks가 필요한 이유

Hooks는 다음 작업에 유용합니다.

- 파일 수정 전 민감 파일 차단
- 파일 수정 후 자동 포맷 실행
- 명령 실행 로그 기록
- Claude가 사용자 입력을 처리하기 전 정책 검사
- 세션 시작 시 이슈나 진행 상태 주입
- 테스트 누락 시 종료를 막고 추가 검증 요청

Hooks는 Claude의 판단에 맡기는 규칙이 아니라, 프로그램으로 실행되는 규칙입니다.

### 설정 위치

| 파일 | 용도 |
| --- | --- |
| `~/.claude/settings.json` | 사용자 전역 설정 |
| `.claude/settings.json` | 프로젝트 공유 설정 |
| `.claude/settings.local.json` | 개인 로컬 프로젝트 설정 |
| 관리형 정책 | 조직/엔터프라이즈 강제 정책 |

팀 전체 규칙은 `.claude/settings.json`, 개인 실험은 `.claude/settings.local.json`에 두는 편이 좋습니다.

### 기본 형태

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run format"
          }
        ]
      }
    ]
  }
}
```

`matcher`는 `PreToolUse`와 `PostToolUse`에서 도구 이름을 매칭합니다. 예를 들어 `Bash`, `Read`, `Edit`, `Write`, `Grep` 등을 대상으로 삼을 수 있습니다.

### 보안 주의사항

Hooks는 자동 실행됩니다. 현재 환경의 권한과 credential을 가지고 실행될 수 있으므로 신중해야 합니다.

금지해야 할 예:

- 검토하지 않은 외부 스크립트 실행
- secret을 로그로 출력
- production 파일 자동 수정
- destructive 명령 자동 실행
- 네트워크로 코드나 데이터를 전송

Hooks는 편리하지만 잘못 만들면 보안 사고가 됩니다.

### 체크리스트

- [ ] Hook이 필요한 이유가 프롬프트 지시보다 강하다.
- [ ] 프로젝트 설정과 개인 설정을 구분한다.
- [ ] 실행 명령이 안전한지 검토했다.
- [ ] 민감 정보 출력 가능성을 확인했다.
- [ ] 실패 시 어떤 동작을 할지 정의했다.

### 다음 단계

다음 장에서는 도구 실행 전 차단할 수 있는 `PreToolUse` Hook을 다룹니다.
