## 031. CLAUDE.md의 역할

난이도: 중급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

![CLAUDE.md 메모리](../assets/04-memory-structure.png)

### 핵심 개념

`CLAUDE.md`는 Claude Code가 프로젝트를 이해할 때 자동으로 참고하는 메모리 파일입니다. 매번 반복해서 설명해야 하는 프로젝트 목적, 실행 명령, 코딩 규칙, 테스트 방식, 금지사항을 담아 두는 곳입니다.

공식 문서 기준으로 `./CLAUDE.md`는 프로젝트 메모리입니다. 팀과 공유할 지침을 저장소에 함께 두는 용도입니다. 개인 취향은 사용자 메모리나 개인 import로 분리하는 편이 안전합니다.

### 왜 필요한가

Claude Code는 매 세션마다 현재 폴더의 파일을 읽을 수 있지만, 팀의 암묵지까지 자동으로 알지는 못합니다.

예를 들어 다음 정보는 코드만 읽어서는 놓치기 쉽습니다.

- 테스트는 항상 단위 테스트 후 통합 테스트 순서로 실행한다.
- `legacy/` 폴더는 수정하지 않는다.
- API 응답 형식은 기존 모바일 앱 호환 때문에 바꾸면 안 된다.
- 마이그레이션은 dry run 로그를 먼저 남긴다.
- 새 패키지는 보안 검토 없이 추가하지 않는다.

이런 규칙을 `CLAUDE.md`에 적어 두면 매번 프롬프트에 반복하지 않아도 됩니다.

### 생성 방법

Claude Code에서는 `/init`으로 프로젝트용 `CLAUDE.md` 초안을 만들 수 있습니다.

```text
/init
```

초안은 그대로 끝내지 말고 팀 규칙에 맞게 다듬어야 합니다. 좋은 `CLAUDE.md`는 길기보다 구체적입니다.

### 기본 템플릿

```markdown
# Project Instructions

## Project Overview

- This repository is a [product/service/library] for [target user].
- Primary language/framework: [stack].
- Main application code lives in `[path]`.
- Tests live in `[path]`.

## Common Commands

- Install: `[command]`
- Run locally: `[command]`
- Lint: `[command]`
- Type check: `[command]`
- Unit tests: `[command]`
- Build: `[command]`

## Working Rules

- Do not modify `[path]` without explicit approval.
- Do not introduce new dependencies unless requested.
- Keep changes scoped to the user request.
- After code changes, run the smallest relevant test first.
- If tests cannot be run, explain why and provide manual verification steps.

## Code Style

- Follow existing patterns before adding new abstractions.
- Prefer [style/pattern] for [area].
- Keep public API compatibility unless the task explicitly asks to change it.

## Security

- Do not read or print secrets from `.env` files.
- Do not include tokens, keys, or customer data in responses.
- Ask before running commands that access external services.
```

위 템플릿에서 대괄호 부분을 실제 프로젝트에 맞게 바꾸면 됩니다.

### 좋은 규칙과 나쁜 규칙

나쁜 규칙:

```markdown
- 코드를 예쁘게 작성한다.
- 테스트를 잘 한다.
- 보안을 조심한다.
```

좋은 규칙:

```markdown
- React 컴포넌트는 `src/components` 아래에 두고, 페이지 전용 컴포넌트는 `src/pages/*/_components`에 둔다.
- API 변경 후에는 `npm run test:api`를 실행한다.
- `.env`, `.env.*`, `secrets/` 아래 파일은 읽거나 출력하지 않는다.
```

Claude가 행동으로 옮길 수 있게 구체적인 파일, 명령, 조건을 적어야 합니다.

### import 활용

`CLAUDE.md`는 `@path/to/file` 문법으로 다른 파일을 참조할 수 있습니다.

```markdown
# Project Instructions

See @README.md for project overview.
See @docs/architecture.md for architecture notes.
See @package.json for available npm scripts.

## Team Rules

- Follow @docs/git-workflow.md for branch and PR conventions.
- Use @docs/testing.md before changing test strategy.
```

단, import를 너무 많이 걸면 시작 컨텍스트가 무거워질 수 있습니다. 항상 필요한 규칙만 직접 적고, 긴 문서는 필요할 때 참조하도록 나누는 편이 좋습니다.

### 실습

현재 프로젝트에서 다음 순서로 진행해 보세요.

1. `/init`으로 `CLAUDE.md` 초안을 만든다.
2. README와 설정 파일을 읽고 실제 실행 명령을 채운다.
3. 수정 금지 폴더와 민감 파일 규칙을 추가한다.
4. 테스트 명령을 작은 테스트와 전체 테스트로 나눈다.
5. 팀원이 읽고 동의할 수 있는 규칙만 남긴다.

### Claude Code에 입력할 프롬프트

```text
이 프로젝트용 CLAUDE.md 초안을 만들어줘.

먼저 확인할 것:
- README
- 패키지 또는 빌드 설정 파일
- 테스트 설정
- 주요 폴더 구조

포함할 것:
1. 프로젝트 개요
2. 자주 쓰는 명령
3. 작업 규칙
4. 테스트 규칙
5. 수정 전 확인해야 할 위험한 영역
6. 민감 파일 처리 규칙

제약:
- 실제 파일 근거가 없는 명령은 추정하지 말고 "확인 필요"라고 표시해줘.
- 아직 파일은 만들지 말고 초안만 보여줘.
```

### 체크리스트

- [ ] 프로젝트 목적과 주요 폴더가 적혀 있다.
- [ ] 설치, 실행, 테스트, 빌드 명령이 실제 설정과 맞다.
- [ ] 수정 금지 또는 승인 필요 영역이 있다.
- [ ] 민감 파일을 읽거나 출력하지 말라는 규칙이 있다.
- [ ] 추상적 표현보다 구체적 행동 규칙이 많다.

### 흔한 실수

- `CLAUDE.md`에 긴 문서 전체를 붙여 넣는다.
- 개인 취향을 팀 규칙처럼 저장소에 커밋한다.
- 실제로 존재하지 않는 테스트 명령을 적는다.
- “잘 작성한다”처럼 행동 기준이 없는 문장을 남긴다.

### 다음 단계

다음 장에서는 자동으로 로드할 메모리와 필요할 때만 참조할 문서를 분리하는 프로젝트 메모리 설계법을 다룹니다.
