## 035. 민감 파일 제외와 컨텍스트 절약

난이도: 중급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Claude Code에서 파일 접근을 제한하려면 2026년 05월 03일 기준 공식 설정인 `.claude/settings.json`의 `permissions.deny`를 사용합니다. 예전식 `ignorePatterns` 설정은 deprecated로 안내되어 있으며, 단순히 `.claudeignore`라는 파일을 만드는 방식에 의존하면 안 됩니다.

즉 이 장의 핵심은 “무엇을 숨길지”와 “어떤 설정으로 숨길지”를 분리해 이해하는 것입니다.

### 왜 필요한가

Claude Code가 읽지 않아야 하는 파일은 두 종류입니다.

| 종류 | 예시 | 이유 |
| --- | --- | --- |
| 민감 파일 | `.env`, `secrets/`, credentials 파일 | 비밀정보 노출 방지 |
| 불필요한 대용량 파일 | `node_modules/`, `dist/`, 로그, 빌드 산출물 | 컨텍스트 낭비와 비용 증가 방지 |

민감 파일은 단순히 “읽지 말아줘”라고 프롬프트에 쓰는 것보다 설정으로 차단하는 편이 안전합니다.

### 공식 설정 예시

프로젝트 공유 설정은 `.claude/settings.json`에 둡니다.

```json
{
  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/)",
      "Read(./config/credentials.json)",
      "Read(./build/)",
      "Read(./dist/)",
      "Read(./node_modules/)"
    ]
  }
}
```

이 설정은 해당 패턴의 파일을 Claude Code가 읽지 못하게 하는 목적입니다.

### 팀 공유와 개인 설정

설정 파일은 성격에 따라 나눕니다.

| 파일 | 용도 |
| --- | --- |
| `.claude/settings.json` | 팀과 공유할 프로젝트 설정 |
| `.claude/settings.local.json` | 개인 실험 또는 로컬 전용 설정 |
| `~/.claude/settings.json` | 모든 프로젝트에 적용할 개인 전역 설정 |

팀 전체가 절대 읽으면 안 되는 파일은 `.claude/settings.json`에 넣는 편이 좋습니다. 개인 로컬 경로만 해당하는 규칙은 `.claude/settings.local.json`이나 사용자 설정에 둡니다.

### deny 후보 목록

프로젝트에서 자주 제외하는 후보는 다음과 같습니다.

```text
.env
.env.*
secrets/
*.pem
*.key
*.p12
credentials.json
service-account*.json
node_modules/
dist/
build/
coverage/
.next/
.gradle/
target/
*.log
```

단, 무조건 많이 막는 것이 정답은 아닙니다. 예를 들어 `coverage/`는 평소에는 불필요하지만 테스트 커버리지 분석 작업에서는 필요할 수 있습니다.

### 프롬프트 규칙도 함께 두기

설정으로 차단하더라도 `CLAUDE.md`에 행동 규칙을 함께 적으면 좋습니다.

```markdown
## Sensitive Files

- Do not read or print secrets from `.env`, `.env.*`, `secrets/`, or credential files.
- If a task appears to require secrets, ask the user to provide redacted structure instead.
- Prefer `.env.example` for documenting environment variables.
```

설정은 접근을 막고, 메모리는 판단 기준을 알려줍니다.

### 컨텍스트 절약 요청

큰 저장소에서는 Claude Code에게 불필요한 폴더를 피해서 읽으라고 요청할 수 있습니다.

```text
프로젝트를 요약해줘.
단, node_modules, dist, build, coverage, 로그 파일은 제외하고
README, 설정 파일, src, tests 중심으로 확인해줘.
```

이 요청은 비용과 시간을 줄이는 데 도움이 됩니다. 다만 민감 파일 차단은 프롬프트보다 `permissions.deny`가 우선입니다.

### 실습

현재 프로젝트에서 다음을 만들어 보세요.

1. 민감 파일 후보 목록
2. 불필요한 대용량 파일 후보 목록
3. `.claude/settings.json`의 `permissions.deny` 초안
4. `CLAUDE.md`에 넣을 민감 정보 처리 규칙
5. 예외적으로 읽어도 되는 문서 목록

### Claude Code에 입력할 프롬프트

```text
이 프로젝트에서 Claude Code가 읽지 않아야 할 파일과 폴더를 검토해줘.

요청:
1. 민감 파일 후보를 찾아줘.
2. 불필요한 대용량/생성 파일 후보를 찾아줘.
3. .claude/settings.json의 permissions.deny 초안을 작성해줘.
4. CLAUDE.md에 넣을 민감 정보 처리 규칙을 제안해줘.
5. 너무 넓게 막아서 작업을 방해할 수 있는 패턴도 지적해줘.

제약:
- 실제 비밀 값은 읽거나 출력하지 마.
- 아직 설정 파일은 만들지 마.
- 공식 settings.json 방식 기준으로 제안해줘.
```

### 체크리스트

- [ ] `.env`, 토큰, 인증 파일을 `permissions.deny`로 차단한다.
- [ ] 빌드 산출물과 의존성 폴더를 필요에 따라 제외한다.
- [ ] 팀 공유 설정과 개인 설정을 구분한다.
- [ ] `CLAUDE.md`에 민감 정보 처리 규칙을 함께 둔다.
- [ ] 너무 넓은 deny 패턴이 정상 작업을 막지 않는지 확인한다.

### 흔한 실수

- `.claudeignore` 파일만 만들고 공식 접근 제한이 된다고 오해한다.
- 민감 파일을 프롬프트 규칙으로만 막는다.
- `Read(./*)`처럼 너무 넓은 규칙으로 작업 자체를 어렵게 만든다.
- `.env.example`까지 막아 환경 변수 문서화를 방해한다.

### 다음 단계

다음 장에서는 기능 개발 전에 요구사항을 `PRD.md`로 정리해 Claude Code가 추측하지 않게 만드는 방법을 다룹니다.
