## 080. 커밋 전 테스트 Hook

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

커밋 전 테스트 Hook은 변경사항이 검증 없이 커밋되는 것을 줄이는 장치입니다. Claude Code Hook만으로 Git pre-commit을 그대로 대체하려고 하기보다, Claude 작업 중 테스트 누락을 감지하고 경고하는 용도로 시작하는 편이 안전합니다.

### Claude Code에서의 접근

`Stop` Hook을 사용하면 Claude가 응답을 끝내려 할 때 테스트 상태를 점검하고, 필요하면 계속 작업하도록 피드백할 수 있습니다.

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python .claude/hooks/check_tests_before_stop.py"
          }
        ]
      }
    ]
  }
}
```

### 간단한 검사 아이디어

```python
import os
import sys

required_marker = ".claude/last-test.txt"

if not os.path.exists(required_marker):
    print(
        "No recent test marker found. Summarize why tests were not run or run the smallest relevant test before stopping.",
        file=sys.stderr,
    )
    sys.exit(2)

sys.exit(0)
```

`Stop` Hook에서 exit code `2`를 반환하면 Claude가 멈추지 않고 후속 조치를 하도록 피드백할 수 있습니다.

### Git pre-commit과의 관계

Git pre-commit은 실제 커밋 시점의 강제 장치입니다. Claude Code Hook은 Claude 세션 중의 작업 흐름 제어입니다.

| 도구 | 역할 |
| --- | --- |
| Claude Code Hook | Claude 작업 중 테스트 누락 피드백 |
| Git pre-commit | 커밋 자체를 막는 로컬 Git hook |
| CI | 원격에서 최종 검증 |

세 가지를 혼동하지 마세요.

### 테스트 마커 설계

`.claude/last-test.txt` 같은 마커를 쓴다면 최소한 다음 정보를 남기세요.

```text
time:
command:
result:
related_files:
notes:
```

마커 파일은 검증 증거를 돕는 보조 장치일 뿐입니다. 실제 테스트 결과를 조작할 수 있으므로 CI나 Git hook을 대체하지 않습니다.

### 미실행 사유 형식

테스트를 실행하지 못한 경우에도 그냥 넘어가지 말고 이유를 남기게 합니다.

```text
테스트 미실행 사유:
- 변경 범위:
- 실행하지 못한 이유:
- 대신 수행한 검증:
- 다음에 실행할 명령:
```

### 체크리스트

- [ ] Hook이 너무 긴 전체 테스트를 강제하지 않는다.
- [ ] 테스트 미실행 사유를 남길 수 있다.
- [ ] Git hook과 CI의 역할을 구분한다.
- [ ] 실패 시 Claude가 무엇을 해야 하는지 메시지가 명확하다.
- [ ] 팀에 강제하기 전 로컬에서 충분히 테스트한다.
- [ ] 테스트 마커에 명령과 결과를 함께 남긴다.
- [ ] CI를 대체하지 않는다는 점을 명시한다.

### 다음 단계

다음 장에서는 명령 실행 로그를 남기는 Hook 패턴을 다룹니다.
