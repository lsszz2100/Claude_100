## 084. stdio MCP와 HTTP MCP

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

MCP는 클라이언트와 서버가 JSON-RPC 메시지를 주고받는 구조입니다. 공식 MCP 사양은 표준 transport로 stdio와 Streamable HTTP를 정의합니다.

어떤 transport를 쓰느냐에 따라 보안, 배포, 인증, 운영 방식이 달라집니다.

### stdio transport

stdio 방식에서는 Claude Code가 MCP 서버를 로컬 subprocess로 실행합니다. 서버는 stdin으로 JSON-RPC 메시지를 받고 stdout으로 응답합니다.

적합한 상황:

- 로컬 파일 도구
- 사내 CLI wrapper
- 개발자 PC에서만 쓰는 도구
- 간단한 프로토타입

주의:

- stdout에는 MCP 메시지만 써야 합니다.
- 로그는 stderr로 보내야 합니다.
- credential은 환경 변수로 전달하는 경우가 많습니다.

예시:

```text
claude mcp add my-tool --env REQUIRED_KEY_NAME=<set-locally> -- node server.js
```

### Streamable HTTP transport

HTTP 방식은 독립 실행 서버가 HTTP endpoint를 통해 MCP 메시지를 받습니다. 원격 서버, OAuth, 여러 클라이언트 연결, 중앙 운영에 더 적합합니다.

적합한 상황:

- SaaS 서비스 MCP
- 팀 공용 MCP 서버
- OAuth 인증이 필요한 서비스
- 원격에서 운영/모니터링할 서버

예시:

```text
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

### 보안 차이

| 항목 | stdio | HTTP |
| --- | --- | --- |
| 실행 위치 | 로컬 subprocess | 원격 또는 독립 서버 |
| 인증 | 환경 변수, 로컬 credential | OAuth, HTTP auth |
| 네트워크 노출 | 낮음 | 높음 |
| 운영 관리 | 개인 환경 중심 | 서버 운영 필요 |
| 주요 위험 | 로컬 권한 남용 | 인증, Origin, 네트워크 공격 |

HTTP MCP 서버는 Origin 검증, 인증, localhost bind 같은 보안 조치가 중요합니다.

### 선택 프롬프트

```text
이 MCP 서버를 stdio와 HTTP 중 어떤 방식으로 운영해야 하는지 판단해줘.

기준:
1. 개인용인지 팀 공용인지
2. 네트워크 접근이 필요한지
3. OAuth가 필요한지
4. credential 저장 방식
5. 운영/모니터링 필요성
6. 보안 위험
```

### 운영 책임 비교

transport 선택은 개발 편의보다 운영 책임을 기준으로 판단해야 합니다.

| 질문 | stdio 쪽 판단 | HTTP 쪽 판단 |
| --- | --- | --- |
| 누가 실행하는가? | 개인 개발자 PC | 서버 운영자 또는 플랫폼 팀 |
| 장애가 나면 누가 대응하는가? | 사용자 본인 | 운영 담당자 |
| 인증을 누가 관리하는가? | 로컬 환경 변수와 credential | OAuth, app 설정, 서버 secret |
| 감사 로그가 필요한가? | 로컬 로그 중심 | 중앙 로그와 audit 필요 |
| 여러 사용자가 함께 쓰는가? | 부적합한 경우 많음 | 적합하지만 격리 필요 |

stdio는 작고 빠르게 시작하기 좋지만, 개인 환경에 묶입니다. HTTP는 팀 공용에 적합하지만 서버 보안과 운영 책임이 커집니다.

### transport별 검토 질문

stdio MCP:

```text
이 stdio MCP 서버를 검토해줘.

확인:
1. stdout에 MCP 메시지만 쓰는가
2. 로그는 stderr로 가는가
3. 환경 변수 secret이 노출되지 않는가
4. 로컬 파일 접근 범위가 제한되는가
5. subprocess 실행 권한이 과도하지 않은가
```

HTTP MCP:

```text
이 HTTP MCP 서버를 검토해줘.

확인:
1. 인증 방식
2. OAuth scope
3. tenant/data isolation
4. Origin 또는 CORS 정책
5. rate limit
6. 로그와 audit
7. token revoke 절차
```

### 운영 팁

처음 만드는 사내 도구라면 stdio로 빠르게 검증하고, 여러 사람이 안정적으로 써야 한다면 HTTP 서버로 운영하는 방식을 검토할 수 있습니다. 다만 HTTP로 바꾸면 배포, 인증, 로그, 장애 대응까지 운영 책임이 커집니다.

HTTP 서버를 운영한다면 최소한 health check, rate limit, 인증 실패 로그, 토큰 회수 절차를 문서화하세요. stdio 서버라면 stdout/stderr 규칙과 환경 변수 secret 처리 방식을 테스트해야 합니다.

### 체크리스트

- [ ] stdio는 로컬 도구에 적합하다.
- [ ] HTTP는 원격/공용 서비스에 적합하다.
- [ ] stdout/stderr 규칙을 이해한다.
- [ ] HTTP 서버는 인증과 Origin 검증을 고려한다.
- [ ] transport 선택을 보안 요구사항과 함께 결정한다.
- [ ] 운영 책임자와 장애 대응 방식을 정했다.
- [ ] secret이 stdout이나 서버 로그에 노출되지 않는다.

### 다음 단계

다음 장에서는 GitHub MCP를 사용해 issue, PR, 코드 리뷰 흐름을 연결하는 방법을 다룹니다.
