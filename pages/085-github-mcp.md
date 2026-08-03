## 085. GitHub MCP

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

GitHub MCP는 Claude Code가 issue, pull request, file, review comment, release 같은 GitHub 정보를 읽거나 조작할 수 있게 합니다. 강력하지만 repository 권한을 직접 다루므로 최소 권한 원칙이 중요합니다.

### 주요 사용 사례

- issue 내용을 읽고 구현 계획 작성
- PR diff 요약
- 리뷰 코멘트 분류
- CI 실패 원인 조사
- 릴리스 노트 초안 작성
- 작은 수정 PR 생성

### 안전한 요청 예시

```text
GitHub MCP를 사용해 issue #123을 읽고 구현 계획만 작성해줘.

제약:
- 아직 브랜치나 PR은 만들지 마.
- 저장소 파일 수정도 하지 마.
- 요구사항, 관련 파일 후보, 테스트 전략, 확인 질문을 정리해줘.
```

PR 리뷰:

```text
PR #456의 변경사항을 리뷰해줘.

초점:
- 버그
- 회귀 위험
- 보안
- 테스트 공백

제약:
- 리뷰 코멘트를 게시하지 말고 초안만 보여줘.
```

### 권한 설계

GitHub 연결에는 보통 다음 권한이 관련됩니다.

- contents read/write
- issues read/write
- pull requests read/write
- actions read
- checks read

처음에는 read 중심으로 시작하고, PR 생성이나 코멘트 작성은 별도 승인 후 허용하세요.

### 권한별 시작 기준

| 작업 | 권장 시작 권한 |
| --- | --- |
| issue 읽기 | read |
| PR diff 읽기 | read |
| CI 로그 확인 | read |
| 리뷰 코멘트 초안 | read, 초안만 |
| PR 생성 | write, 승인 후 |
| issue 상태 변경 | write, 승인 후 |
| release 생성 | 별도 승인 |

### 쓰기 작업 승인 기준

GitHub MCP의 쓰기 작업은 팀 기록에 바로 남습니다. 다음 작업은 초안과 승인 단계를 분리하세요.

- PR 생성
- PR 리뷰 코멘트 게시
- issue 댓글 작성
- issue 상태 변경
- label, milestone, assignee 변경
- release와 tag 생성

승인 전에는 “게시될 정확한 문장”, “대상 issue/PR 번호”, “변경되는 상태”를 먼저 보여주게 합니다.

### 좋은 워크플로

1. GitHub MCP로 issue 또는 PR을 읽는다.
2. 요구사항, 변경사항, 테스트 상태를 요약한다.
3. 로컬 코드베이스와 연결해 관련 파일을 찾는다.
4. 계획이나 리뷰 초안을 만든다.
5. 쓰기 작업은 사용자 승인 후 진행한다.
6. PR 코멘트나 issue 댓글은 게시 전 초안을 보여준다.

### issue 기반 구현 요청

```text
GitHub MCP로 issue #123을 읽고, 로컬 코드베이스 기준 구현 계획을 작성해줘.

출력:
1. 요구사항 요약
2. 모호한 점과 확인 질문
3. 수정 후보 파일
4. 테스트 전략
5. 예상 위험
6. 구현 전 승인받아야 할 결정

제약:
- 브랜치 생성 금지
- PR 생성 금지
- issue 댓글 작성 금지
- 파일 수정 금지
```

### GitHub Actions와의 차이

| 방식 | 특징 |
| --- | --- |
| GitHub MCP | Claude Code 세션에서 GitHub를 도구처럼 사용 |
| Claude Code GitHub Actions | `@claude` 멘션이나 workflow로 GitHub runner에서 실행 |

MCP는 대화형 탐색에 좋고, GitHub Actions는 PR/issue 기반 자동화에 좋습니다.

### 위험 신호

- issue 읽기와 상태 변경을 한 요청에 섞는다.
- PR 리뷰 초안 없이 바로 코멘트를 게시한다.
- repository 전체 write 권한을 기본으로 둔다.
- CI 실패 로그에 secret이 포함될 가능성을 검토하지 않는다.
- 릴리스 생성이나 태그 작업을 자동화한다.

### 체크리스트

- [ ] 처음에는 read-only 작업으로 시작한다.
- [ ] PR 생성/코멘트 작성은 승인 후 진행한다.
- [ ] GitHub App 권한을 최소화한다.
- [ ] CI 결과와 diff를 함께 검토한다.
- [ ] 자동화는 `CLAUDE.md` 프로젝트 규칙을 따르게 한다.
- [ ] 게시 전 정확한 댓글/리뷰 내용을 확인한다.
- [ ] release와 tag 작업은 별도 승인 절차를 둔다.

### 다음 단계

다음 장에서는 Database MCP를 안전하게 연결하는 방법을 다룹니다.
