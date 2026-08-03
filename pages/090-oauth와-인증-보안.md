## 090. OAuth와 인증 보안

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

HTTP 기반 MCP 서버는 OAuth 같은 인증 흐름을 사용할 수 있습니다. Claude Code도 `/mcp` 메뉴를 통해 OAuth 인증을 진행하고, 토큰을 저장하고, 필요하면 인증을 해제할 수 있습니다.

인증 보안의 핵심은 “연결이 되는가”가 아니라 “어떤 권한을 얼마 동안 누구에게 주는가”입니다.

### 확인할 항목

- OAuth scope
- token 저장 위치와 보호 방식
- refresh token 사용 여부
- token revoke 방법
- 조직 퇴사/권한 변경 시 회수 절차
- audit log
- multi-tenant 데이터 격리

### scope 판단 기준

OAuth 승인 화면에서 요청 scope를 그대로 승인하지 말고, 작업 목적과 비교하세요.

| 요청 목적 | 과도한 scope 예시 | 더 나은 기준 |
| --- | --- | --- |
| issue 읽기 | repo 전체 write | issues read |
| PR 검토 | contents write | pull requests read, checks read |
| 문서 요약 | workspace 전체 read | 특정 문서/프로젝트 read |
| 댓글 초안 | write 기본 허용 | 초안 생성 후 승인 시 write |

scope가 넓은데 줄일 방법이 없다면 도입을 보류하거나 별도 sandbox 계정으로 검증하세요.

### OAuth 연결 전 질문

```text
이 MCP 서버의 OAuth 권한을 검토해줘.

확인할 것:
1. 요청하는 scope
2. 읽기/쓰기 권한
3. 조직 전체 접근 여부
4. 토큰 저장 위치
5. revoke 방법
6. 최소 권한 대안
```

### `/mcp`에서 할 일

```text
/mcp
```

`/mcp`에서는 연결 상태, 인증 상태, OAuth 로그인, 인증 해제 등을 확인합니다. 브라우저가 자동으로 열리지 않으면 제공된 URL을 복사해 인증할 수 있습니다.

### stdio와 OAuth

공식 MCP 사양에서 HTTP 기반 transport는 authorization 흐름을 정의하지만, stdio transport는 보통 환경 변수나 로컬 credential을 사용합니다. 따라서 stdio MCP는 환경 변수 관리와 로컬 secret 보호가 중요합니다.

### 권한 검토 표

| 질문 | 확인 이유 |
| --- | --- |
| 어떤 scope를 요청하는가? | 읽기/쓰기 범위 확인 |
| 조직 전체 접근인가? | blast radius 확인 |
| refresh token이 있는가? | 장기 접근 가능성 확인 |
| revoke가 쉬운가? | 사고 대응 가능성 확인 |
| 토큰 저장 위치가 어디인가? | 로컬/서버 보안 확인 |
| 감사 로그가 남는가? | 사후 추적 가능성 확인 |

### 토큰 회수 절차 템플릿

```text
MCP OAuth 토큰 회수 절차:
1. 영향 받는 사용자/조직 확인
2. 연결된 MCP 서버 목록 확인
3. 해당 서비스에서 app access revoke
4. Claude Code /mcp에서 연결 해제
5. 로컬 credential 저장소 확인
6. 감사 로그에서 최근 tool 호출 확인
7. 필요 시 토큰 재발급
```

### 팀 운영 기준

- 개인 계정보다 서비스 계정 또는 조직 관리 앱을 우선 검토한다.
- write scope는 사용 사례가 명확할 때만 허용한다.
- 퇴사자와 외부 협력자 권한 회수를 정기 점검한다.
- OAuth 승인 화면을 캡처하거나 문서화해 요청 scope를 기록한다.

### 사고 대응 기준

토큰 노출이나 오용이 의심되면 다음 순서로 처리합니다.

1. 해당 MCP 연결을 즉시 해제한다.
2. 서비스 제공자 쪽에서 app access를 revoke한다.
3. 최근 tool 호출과 audit log를 확인한다.
4. 영향을 받은 저장소, 문서, 채널, DB 범위를 확인한다.
5. 필요한 경우 새 credential을 발급하고 권한을 줄인다.
6. 재발 방지를 위해 scope와 보관 위치를 수정한다.

### 체크리스트

- [ ] OAuth scope를 확인한다.
- [ ] 읽기/쓰기 권한을 분리한다.
- [ ] revoke 절차를 알고 있다.
- [ ] stdio 서버의 환경 변수 secret을 보호한다.
- [ ] 권한 변경과 퇴사자 회수 절차를 문서화한다.
- [ ] 요청 목적보다 넓은 scope는 보류한다.
- [ ] 토큰 노출 시 회수와 감사 절차가 있다.

### 다음 단계

다음 장에서는 MCP 서버를 도입하기 전 검증 체크리스트를 정리합니다.
