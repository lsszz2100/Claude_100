## 076. PreToolUse Hook

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

`PreToolUse` Hook은 Claude가 도구를 실행하기 직전에 호출됩니다. 파일 읽기, 파일 수정, Bash 실행 같은 작업이 실제로 수행되기 전에 검사하거나 차단할 수 있습니다.

위험한 작업을 막는 데 가장 중요한 Hook입니다.

### 사용 사례

- `.env` 파일 읽기 차단
- `rm -rf` 같은 destructive 명령 차단
- production 설정 파일 수정 차단
- 특정 폴더의 `Write` 또는 `Edit` 차단
- migration 실행 전 승인 요구

### 설정 예시

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "python .claude/hooks/block_dangerous_bash.py"
          }
        ]
      }
    ]
  }
}
```

Hook 명령은 stdin으로 JSON 입력을 받고, exit code로 결과를 전달합니다. 공식 문서 기준으로 exit code `2`는 차단 동작에 사용됩니다. `PreToolUse`에서 exit code `2`를 반환하면 도구 호출이 차단되고 stderr가 Claude에게 전달됩니다.

### 차단 스크립트 예시

```python
import json
import re
import sys

data = json.load(sys.stdin)
command = data.get("tool_input", {}).get("command", "")

blocked = [
    r"\brm\s+-rf\b",
    r"\bgit\s+reset\s+--hard\b",
    r"\bkubectl\s+delete\b",
    r"\bterraform\s+apply\b",
]

for pattern in blocked:
    if re.search(pattern, command):
        print(f"Blocked dangerous command: {command}", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
```

### 파일 읽기 차단 예시

```python
import json
import sys

data = json.load(sys.stdin)
path = data.get("tool_input", {}).get("file_path", "")

blocked = [".env", "secrets/", "credentials.json"]

if any(item in path for item in blocked):
    print(f"Blocked reading sensitive file: {path}", file=sys.stderr)
    sys.exit(2)

sys.exit(0)
```

### 주의할 점

너무 넓게 차단하면 작업이 불가능해집니다. 예를 들어 `.env.example`은 문서화에 필요할 수 있으므로 `.env`와 구분해야 합니다.

### 차단과 확인 요청의 차이

모든 위험 작업을 즉시 차단할 필요는 없습니다. 위험도에 따라 차단, 경고, 승인 요청을 나눕니다.

| 처리 | 예시 |
| --- | --- |
| 차단 | 실제 secret 파일 읽기, 운영 DB 변경, 강제 삭제 |
| 승인 요청 | 의존성 설치, 긴 테스트, 외부 네트워크 호출 |
| 경고 | 큰 파일 읽기, 생성 파일 수정, 포맷 범위 확대 |

Hook 메시지에는 “왜 막았는지”와 “대신 무엇을 해야 하는지”가 함께 있어야 합니다. 단순히 실패만 반환하면 Claude가 같은 시도를 반복할 수 있습니다.

### 테스트 방법

Hook은 실제 작업에 붙이기 전에 샘플 입력으로 테스트하세요.

```text
허용되어야 하는 명령:
- npm test
- git diff

차단되어야 하는 명령:
- git reset --hard
- terraform apply
- rm -rf dist
```

허용 사례와 차단 사례를 모두 테스트해야 정상 작업을 막는 회귀를 줄일 수 있습니다.

### 체크리스트

- [ ] 차단할 도구와 패턴이 명확하다.
- [ ] exit code `2`의 의미를 이해한다.
- [ ] stderr 메시지가 Claude에게 다음 행동을 알려준다.
- [ ] 너무 넓은 차단으로 정상 작업을 막지 않는다.
- [ ] Hook 스크립트를 팀이 검토했다.
- [ ] 차단, 승인 요청, 경고를 구분했다.
- [ ] 허용 사례와 차단 사례를 모두 테스트했다.

### 다음 단계

다음 장에서는 도구 실행 후 자동 포맷이나 검사를 실행하는 `PostToolUse` Hook을 다룹니다.
