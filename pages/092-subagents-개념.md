## 092. Subagents 개념

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Subagent는 특정 역할과 도구 권한을 가진 전문 AI 작업자입니다. Claude Code는 작업 설명, subagent의 `description`, 현재 맥락을 바탕으로 적합한 subagent를 자동으로 사용하거나, 사용자가 명시적으로 호출할 수 있습니다.

중요한 장점은 별도 context window입니다. 메인 대화의 맥락을 오염시키지 않고 특정 작업을 맡길 수 있습니다. 반대로 말하면 subagent에게 줄 작업 범위와 산출물 형식을 명확히 써야 합니다.

### 기본 구조

```text
.claude/
  agents/
    code-reviewer.md
    test-engineer.md
    docs-writer.md
```

파일 형식:

````markdown
---
name: code-reviewer
description: Reviews code changes for bugs, regressions, security issues, and missing tests. Use for PR review, diff review, and pre-merge checks.
tools: Read, Grep, Glob
---

You are a code review specialist.
Lead with findings ordered by severity.
Focus on bugs, regressions, security, and missing tests.
````

### 언제 쓰는가

Subagent는 작업의 기준이 명확하고, 독립적으로 판단할 수 있는 범위가 있을 때 효과적입니다.

| 상황 | 적합한 subagent |
| --- | --- |
| diff 검토 | 코드 리뷰어 |
| 실패 테스트 분석 | 테스트 엔지니어 |
| README 갱신 | 문서 작성자 |
| 권한/인증 검토 | 보안 리뷰어 |
| 작은 기능 구현 | 구현 에이전트 |

### 역할 분리 원칙

Subagent를 여러 개 만들 때는 역할 이름보다 책임 경계가 중요합니다.

| 구분 | 좋은 기준 |
| --- | --- |
| 입력 | 어떤 파일, diff, 로그를 읽는가 |
| 판단 | 무엇을 우선순위로 삼는가 |
| 권한 | 읽기만 하는가, 수정도 가능한가 |
| 산출물 | findings, 계획, 패치, 테스트 결과 중 무엇인가 |
| 종료 조건 | 어떤 상태가 되면 작업이 끝나는가 |

예를 들어 `code-reviewer`와 `security-reviewer`가 모두 “코드 검토”를 한다고 쓰면 역할이 겹칩니다. 전자는 회귀와 테스트 공백을 중심으로 보고, 후자는 공격 시나리오와 권한 우회를 중심으로 보게 나누는 편이 좋습니다.

### 쓰지 않는 편이 좋은 상황

- 요구사항이 아직 모호하다.
- 바로 다음 행동이 subagent 결과에 막혀 있다.
- 같은 파일을 여러 subagent가 동시에 수정해야 한다.
- 운영 배포, DB migration, 인증 정책처럼 단일 책임자의 판단이 필요한 작업이다.

### 좋은 description

`description`은 Claude Code가 언제 이 subagent를 써야 하는지 판단하는 핵심 단서입니다. 막연한 설명보다 사용 조건을 적어야 합니다.

나쁜 예:

```text
Helps with code.
```

좋은 예:

```text
Use after code changes to review diffs for correctness bugs, regressions, security risks, and missing tests before merge.
```

### 호출 요청 예시

```text
코드 리뷰어 subagent를 사용해 현재 변경사항을 검토해줘.

초점:
- 버그
- 회귀
- 보안 위험
- 테스트 공백

출력:
- finding 우선
- 심각도 포함
- 파일과 라인 근거 포함
- 문제가 없으면 명확히 "중요 이슈 없음"이라고 말해줘.
```

### 설계 체크리스트

- [ ] 역할이 한 문장으로 분명하다.
- [ ] 사용할 도구 권한이 최소화되어 있다.
- [ ] 산출물 형식이 고정되어 있다.
- [ ] 수정 권한이 필요한지 읽기 전용이면 충분한지 구분했다.
- [ ] 실패했을 때 메인 세션이 판단할 수 있는 요약을 남긴다.
- [ ] 역할이 다른 subagent와 겹치지 않는다.
- [ ] 종료 조건과 다음 인계 방식이 정해져 있다.

### 다음 단계

다음 장에서는 가장 자주 쓰이는 코드 리뷰어 에이전트를 설계합니다.
