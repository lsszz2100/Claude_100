## 087. Filesystem MCP

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Filesystem MCP는 Claude가 파일시스템을 읽고 쓸 수 있게 합니다. 편리하지만 범위 제한을 잘못하면 민감 파일, 홈 디렉터리, SSH 키, credential에 접근할 수 있습니다.

파일시스템 도구의 핵심은 allowlist입니다.

### 허용 범위 설계

```text
허용:
- 현재 프로젝트 루트
- docs/
- src/
- tests/

차단:
- ~/.ssh
- ~/.aws
- ~/.config
- .env
- secrets/
- 개인 다운로드 폴더
- 운영 credential
```

### 안전한 요청

```text
Filesystem MCP로 현재 프로젝트 docs 폴더만 분석해줘.

제약:
- docs/ 밖의 파일은 읽지 마.
- 파일 수정은 하지 마.
- 민감 정보처럼 보이는 값은 출력하지 마.
```

### 위험한 작업

- 홈 디렉터리 전체 스캔
- 모든 `.env` 검색
- 대량 파일명 변경
- 삭제/이동 자동화
- credential 파일 요약

### 경로 정책

Filesystem MCP는 경로 정책이 전부입니다.

| 정책 | 설명 |
| --- | --- |
| allowlist | 접근 가능한 루트를 명시한다 |
| denylist | secret, credential, 홈 설정 경로를 차단한다 |
| read-only default | 처음에는 읽기 전용으로 시작한다 |
| write approval | 쓰기 작업은 변경 전/후 표를 승인받는다 |
| generated files | 생성 파일은 원본 수정 경로를 안내한다 |

Windows에서는 OneDrive, 바탕 화면, 한글 경로처럼 동기화나 권한 문제가 섞일 수 있습니다. 대량 작업 전에는 실제 절대 경로와 대상 파일 수를 먼저 확인하세요.

### 설정 검토 프롬프트

```text
Filesystem MCP 설정을 보안 관점으로 검토해줘.

확인할 것:
1. 허용된 루트 경로
2. 홈 디렉터리 노출 여부
3. secret 파일 접근 가능성
4. 쓰기 권한 필요 여부
5. 프로젝트 작업에 필요한 최소 범위
6. 차단해야 할 경로
```

### dry run 우선 원칙

파일 작업은 먼저 미리보기로 시작합니다.

```text
현재 폴더의 Markdown 파일명을 정리하고 싶다.

먼저 dry run 결과만 보여줘.
출력:
- 현재 파일명
- 제안 파일명
- 변경 이유
- 충돌 가능성

내가 승인하기 전에는 파일 이름을 바꾸지 마.
```

### 쓰기 권한을 줄 때의 기준

Filesystem MCP에 쓰기 권한을 줄 때는 다음 질문에 답할 수 있어야 합니다.

- 수정 대상 경로가 프로젝트 내부인가?
- 백업이나 버전 관리가 있는가?
- 삭제보다 이동/이름 변경이 필요한가?
- 대량 변경 전에 샘플 3개로 검증했는가?
- secret 파일과 build artifact를 제외했는가?

### 차단 메시지 예시

```text
이 경로는 Filesystem MCP 허용 범위 밖입니다.
허용된 루트: docs/, src/, tests/
필요하다면 사용자가 명시적으로 범위를 승인해야 합니다.
```

### 안전한 allowlist 예시

```text
허용:
- C:\work\project\docs
- C:\work\project\src
- C:\work\project\tests

차단:
- C:\Users\me\.ssh
- C:\Users\me\.aws
- C:\Users\me\Downloads
- .env
- secrets/
```

### 체크리스트

- [ ] 허용 경로를 프로젝트 단위로 제한한다.
- [ ] 홈 디렉터리 전체를 열지 않는다.
- [ ] secret 파일과 credential 경로를 차단한다.
- [ ] 쓰기 권한은 필요할 때만 허용한다.
- [ ] 대량 파일 작업은 dry run으로 시작한다.
- [ ] 절대 경로와 대상 파일 수를 실행 전에 확인한다.
- [ ] generated file은 직접 수정하지 않도록 안내한다.

### 다음 단계

다음 장에서는 Browser/Chrome MCP를 프론트엔드 검증에 활용하는 방법을 다룹니다.
