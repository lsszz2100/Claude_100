## 034. 디렉터리별 CLAUDE.md

난이도: 중급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

큰 저장소에서는 모든 규칙을 루트 `CLAUDE.md` 하나에 넣기 어렵습니다. Claude Code는 현재 작업 위치에서 상위 디렉터리의 메모리를 읽고, 하위 트리의 `CLAUDE.md`도 해당 파일을 읽을 때 참고할 수 있습니다.

따라서 `api/`, `web/`, `tests/`처럼 성격이 다른 폴더에는 디렉터리별 `CLAUDE.md`를 둘 수 있습니다.

### 언제 필요한가

디렉터리별 메모리는 다음 상황에서 유용합니다.

- 모노레포 안에 프론트엔드와 백엔드가 함께 있다.
- `infra/` 폴더에는 운영상 위험한 Terraform 또는 배포 코드가 있다.
- `tests/` 폴더는 본문 코드와 다른 작성 규칙을 가진다.
- `generated/` 폴더는 직접 수정하면 안 된다.
- 팀별 소유권이 폴더 단위로 나뉜다.

### 추천 구조

```text
repo/
  CLAUDE.md
  apps/
    web/
      CLAUDE.md
      src/
  services/
    api/
      CLAUDE.md
      src/
  tests/
    CLAUDE.md
```

루트 `CLAUDE.md`에는 저장소 전체 규칙을 둡니다.

```markdown
# Repository Rules

- Keep changes scoped to the requested package.
- Do not edit generated files directly.
- Ask before changing shared CI, deployment, or permission settings.
- Run the smallest relevant test for the touched package first.
```

`apps/web/CLAUDE.md`에는 프론트엔드 규칙을 둡니다.

```markdown
# Web App Rules

- Use existing components from `src/components/ui` before creating new primitives.
- Keep route-level data loading in `src/routes`.
- Run `npm run test:web` for component or route changes.
- Do not introduce global CSS unless explicitly requested.
```

`services/api/CLAUDE.md`에는 API 규칙을 둡니다.

```markdown
# API Service Rules

- Preserve existing response shapes unless the task explicitly changes the API contract.
- Add or update request validation tests for endpoint changes.
- Run `npm run test:api` after handler or schema changes.
- Do not change migrations without a rollback note.
```

### 중복을 줄이는 법

디렉터리별 파일에 루트 규칙을 다시 복사하지 마세요. 루트에는 공통 규칙, 하위 폴더에는 지역 규칙만 둡니다.

나쁜 예:

```markdown
# apps/web/CLAUDE.md

- Keep changes scoped.
- Ask before changing CI.
- Do not edit generated files.
- Use existing UI components.
- Run web tests.
```

좋은 예:

```markdown
# apps/web/CLAUDE.md

- Use existing UI components from `src/components/ui`.
- Run `npm run test:web` for changes in this package.
- Keep accessibility behavior consistent with `docs/a11y.md`.
```

### 위험한 폴더 표시

운영 설정이나 인프라 폴더에는 강한 경고를 둘 수 있습니다.

```markdown
# Infrastructure Rules

- Do not apply Terraform changes from Claude Code.
- Do not modify production variables without explicit approval.
- For plan changes, produce a written review summary before suggesting commands.
- Never print secret values from state files or environment files.
```

이런 규칙은 단순 편의가 아니라 사고 예방 장치입니다.

### 실습

현재 프로젝트가 다음 구조라고 가정하고 각 폴더별 `CLAUDE.md` 초안을 만들어 보세요.

```text
project/
  CLAUDE.md
  web/
  api/
  tests/
  infra/
```

각 파일에는 공통 규칙이 아니라 해당 폴더에서만 필요한 규칙을 넣습니다.

### Claude Code에 입력할 프롬프트

```text
이 저장소에 디렉터리별 CLAUDE.md가 필요한지 검토해줘.

요청:
1. 폴더 구조를 확인해줘.
2. 루트 CLAUDE.md에 둘 공통 규칙을 제안해줘.
3. 하위 폴더별로 별도 CLAUDE.md가 필요한지 판단해줘.
4. 필요한 경우 각 파일 초안을 작성해줘.
5. 중복되거나 충돌할 수 있는 규칙을 표시해줘.

제약:
- 아직 파일은 만들지 마.
- 실제 폴더 구조를 근거로 제안해줘.
- 보안/배포/인프라 폴더는 위험도를 따로 표시해줘.
```

### 체크리스트

- [ ] 루트에는 저장소 전체 규칙만 둔다.
- [ ] 하위 폴더에는 그 폴더 전용 규칙만 둔다.
- [ ] 같은 규칙을 여러 파일에 반복하지 않는다.
- [ ] 인프라, 배포, 생성 코드 폴더에는 명확한 경고를 둔다.
- [ ] 하위 규칙이 루트 규칙과 충돌하지 않는다.

### 흔한 실수

- 모든 하위 폴더에 기계적으로 `CLAUDE.md`를 만든다.
- 루트 규칙을 하위 파일에 그대로 복사한다.
- 폴더별 테스트 명령을 실제 설정과 다르게 적는다.
- 위험한 폴더에 수정 금지 조건을 적지 않는다.

### 다음 단계

다음 장에서는 민감 파일과 불필요한 파일을 Claude Code 접근 범위에서 제외하는 공식 설정 방식을 다룹니다.
