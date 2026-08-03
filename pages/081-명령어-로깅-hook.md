## 081. 명령어 로깅 Hook

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

명령어 로깅 Hook은 Claude Code가 실행하려는 Bash 명령이나 실행 후 결과를 기록하는 패턴입니다. 디버깅, 감사, 팀 운영 정책 확인에 유용하지만, 비밀정보를 로그에 남기지 않도록 주의해야 합니다.

### PreToolUse 로깅 예시

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python .claude/hooks/log_bash.py"
          }
        ]
      }
    ]
  }
}
```

### 스크립트 예시

```python
import datetime
import json
import re
import sys

data = json.load(sys.stdin)
command = data.get("tool_input", {}).get("command", "")

redacted = re.sub(r"(API_KEY|TOKEN|PASSWORD|SECRET)=\\S+", r"\\1=[redacted]", command)

with open(".claude/command-log.ndjson", "a", encoding="utf-8") as f:
    f.write(json.dumps({
        "time": datetime.datetime.utcnow().isoformat() + "Z",
        "command": redacted,
    }, ensure_ascii=False) + "\\n")

sys.exit(0)
```

### 로그에 남기면 안 되는 것

- 실제 API 키
- 토큰
- 비밀번호
- 고객 개인정보
- 전체 `.env` 내용
- 민감한 경로와 내부 시스템 정보

로깅은 보안 도구가 될 수도 있고, 보안 사고 원인이 될 수도 있습니다.

### 로그 필드 기준

처음에는 최소 필드만 남기세요.

| 필드 | 이유 |
| --- | --- |
| time | 언제 실행했는지 확인 |
| command_redacted | 민감 정보를 제거한 명령 |
| cwd | 어느 프로젝트에서 실행했는지 확인 |
| purpose | 사용자가 요청한 작업과 연결 |
| result | 성공, 실패, 차단 구분 |

명령 전체를 남기지 않아도 되는 환경이라면 명령 유형만 남기는 편이 더 안전합니다.

### 보관과 접근 권한

명령 로그는 오래 보관할수록 위험도 커집니다.

- 로컬 개발 로그는 짧게 보관한다.
- 팀 공유 로그는 접근 권한을 제한한다.
- secret redaction 테스트를 정기적으로 실행한다.
- 로그 파일은 백업이나 동기화 대상에서 제외한다.
- 보안 사고가 의심되면 로그도 함께 점검한다.

### 운영 팁

- 로그 파일을 Git에 커밋하지 않는다.
- `.gitignore`에 `.claude/command-log.ndjson`를 추가한다.
- redaction 규칙을 테스트한다.
- 민감 명령은 로그 대신 차단하는 편이 나을 수 있다.

### 체크리스트

- [ ] 로그 목적이 명확하다.
- [ ] secret redaction이 있다.
- [ ] 로그 파일이 Git에 커밋되지 않는다.
- [ ] 개인정보와 고객 데이터를 남기지 않는다.
- [ ] 차단해야 할 명령과 기록만 할 명령을 구분한다.
- [ ] 로그 보관 기간과 접근 권한을 정했다.
- [ ] 명령 전체가 꼭 필요한지 검토했다.

### 다음 단계

다음 장에서는 Hooks를 설계할 때 반드시 고려해야 할 보안 원칙을 정리합니다.
