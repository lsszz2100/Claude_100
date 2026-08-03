## 070. 테스트 Skill 만들기

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

테스트 Skill은 프로젝트마다 다른 테스트 명령, 실패 로그 읽기 방식, 최소 검증 기준을 재사용 가능하게 만듭니다. 다만 테스트 실행은 명령 실행 권한이 필요하므로 도구 권한을 신중히 설정해야 합니다.

### 폴더 구조

```text
.claude/
  skills/
    test-runner/
      SKILL.md
      references/
        test-strategy.md
```

### SKILL.md 예시

```markdown
---
name: Test Runner
description: Find and run the smallest relevant tests, analyze failures, and summarize verification results. Use after code changes, when tests fail, or when the user asks what tests to run.
allowed-tools: Read, Grep, Glob, Bash
---

# Test Runner

## Instructions

1. Identify the package manager and test commands from project files.
2. Prefer the smallest relevant test before running broad suites.
3. When tests fail, separate the first failing cause from cascading errors.
4. Never delete or weaken tests just to make them pass.
5. Summarize commands run and results.

## Safety

- Ask before running long or destructive commands.
- Do not run deployment, migration, or production commands.
- If the test command is unclear, stop and ask.

## Output Format

- Test command:
- Result:
- First failure:
- Likely cause:
- Suggested fix:
- Next verification:
```

`Bash`를 허용할 경우 너무 넓은 실행 권한이 될 수 있습니다. 팀 환경에서는 프로젝트 정책에 맞게 제한하거나, Skill 본문에 금지 명령을 명확히 적어야 합니다.

### 실패 로그 분석 규칙

테스트 Skill에는 다음 규칙이 있어야 합니다.

- 마지막 줄 요약만 보지 않는다.
- 최초 실패 지점을 찾는다.
- 테스트 작성 오류와 제품 코드 오류를 구분한다.
- flaky 가능성을 별도로 표시한다.
- 실행하지 못한 테스트는 이유를 남긴다.

### 테스트 선택 기준

작은 테스트부터 실행한다는 원칙은 무작정 빠른 테스트만 고르라는 뜻이 아닙니다. 변경 파일과 가장 가까운 검증부터 시작하고, 위험이 크면 넓은 검증으로 확장합니다.

| 변경 유형 | 먼저 실행할 테스트 | 추가 검증 |
| --- | --- | --- |
| 단일 함수 수정 | 해당 단위 테스트 | 관련 경계 조건 테스트 |
| UI 컴포넌트 수정 | 컴포넌트 테스트 | 주요 화면 스모크 테스트 |
| API 변경 | 엔드포인트 테스트 | 계약 테스트와 오류 응답 |
| DB 변경 | 마이그레이션 테스트 | 롤백과 기존 데이터 확인 |
| 의존성 업데이트 | 관련 패키지 테스트 | 전체 빌드와 핵심 회귀 테스트 |

### 결과 요약 기준

테스트 Skill은 단순히 성공 또는 실패만 말하면 부족합니다. 실행한 명령, 걸린 시간, 실패한 첫 지점, 재실행할 명령, 아직 실행하지 않은 검증을 함께 남겨야 다음 작업자가 이어받을 수 있습니다.

### 체크리스트

- [ ] 테스트 명령을 실제 설정 파일에서 찾게 한다.
- [ ] 작은 관련 테스트 우선 원칙이 있다.
- [ ] 실패 로그 분석 기준이 있다.
- [ ] 금지 명령이 명확하다.
- [ ] 실행 결과 요약 형식이 고정되어 있다.
- [ ] 변경 유형별 테스트 선택 기준이 있다.
- [ ] 미실행 검증을 숨기지 않는다.

### 다음 단계

다음 장에서는 문서 생성과 문서 검토를 Skill로 만드는 방법을 다룹니다.
