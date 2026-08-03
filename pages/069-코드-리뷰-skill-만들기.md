## 069. 코드 리뷰 Skill 만들기

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

코드 리뷰 Skill은 반복되는 리뷰 기준을 팀 표준으로 고정하는 데 유용합니다. 리뷰는 칭찬보다 버그, 회귀, 보안, 테스트 공백을 우선해야 합니다.

읽기 전용 리뷰 Skill이라면 `allowed-tools: Read, Grep, Glob`로 제한하는 것이 좋습니다.

### 폴더 구조

```text
.claude/
  skills/
    code-reviewer/
      SKILL.md
      references/
        severity.md
```

### SKILL.md 예시

```markdown
---
name: Code Reviewer
description: Review code diffs and pull request changes for bugs, regressions, security risks, and missing tests. Use when the user asks for code review, PR review, diff review, or pre-merge risk analysis.
allowed-tools: Read, Grep, Glob
---

# Code Reviewer

## Instructions

1. Lead with findings ordered by severity.
2. Focus on bugs, regressions, security, and missing tests.
3. Include file and line references when possible.
4. Avoid style-only comments unless they hide a real risk.
5. If no major issues are found, say so clearly.

## Severity

- Critical: likely data loss, security breach, or production outage.
- High: likely user-facing bug or serious regression.
- Medium: plausible bug, missing validation, or important test gap.
- Low: maintainability issue with limited immediate impact.

## Output Format

## Findings

- Severity:
- File/Line:
- Problem:
- Why it matters:
- Suggested fix:

## Test Gaps

- [missing test]

## Open Questions

- [question]
```

### 테스트 프롬프트

Skill을 만든 뒤에는 실제 요청으로 동작을 확인합니다.

```text
현재 git diff를 코드 리뷰해줘.
버그, 회귀, 보안, 테스트 공백을 우선해줘.
```

Claude가 Skill을 사용하지 않는다면 `description`이 너무 모호한지 확인합니다.

### 리뷰 범위 정하기

코드 리뷰 Skill이 모든 문제를 한 번에 다루려 하면 결과가 흐려집니다. 팀에서 먼저 필요한 리뷰 범위를 정하세요.

| 범위 | 우선 확인할 것 |
| --- | --- |
| 버그 리뷰 | 조건 분기, null 처리, 예외 처리, 데이터 손실 |
| 보안 리뷰 | 인증, 권한, 입력 검증, 비밀정보 노출 |
| 테스트 리뷰 | 핵심 경로, 실패 경로, 회귀 테스트 |
| 변경 영향 리뷰 | API 계약, DB 스키마, 설정, 배포 영향 |

Skill 설명에는 이 범위를 모두 넣기보다 “diff review”, “PR review”, “pre-merge risk analysis”처럼 호출 조건을 분명히 적는 편이 좋습니다.

### 좋은 리뷰 결과의 조건

- 문제 위치가 파일과 줄 기준으로 좁혀져 있다.
- 실제로 실패할 수 있는 경로를 설명한다.
- 심각도와 근거가 함께 있다.
- 수정 제안이 원래 의도를 깨지 않는다.
- 테스트 공백을 별도 섹션으로 남긴다.

### 체크리스트

- [ ] review 대상과 사용 시점이 description에 들어 있다.
- [ ] findings first 형식이 명확하다.
- [ ] severity 기준이 있다.
- [ ] 읽기 전용 도구만 허용한다.
- [ ] 스타일 리뷰보다 버그와 회귀를 우선한다.
- [ ] 리뷰 범위가 너무 넓지 않다.
- [ ] 테스트 공백을 별도로 보고한다.

### 다음 단계

다음 장에서는 테스트 실행과 실패 분석을 Skill로 만드는 방법을 다룹니다.
