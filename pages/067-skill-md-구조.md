## 067. SKILL.md 구조

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

`SKILL.md`는 Skill의 진입점입니다. Claude는 frontmatter의 `name`과 `description`을 보고 Skill을 언제 사용할지 판단하고, 필요할 때 본문을 읽습니다.

따라서 `description`은 가장 중요합니다. “무엇을 하는지”와 “언제 사용해야 하는지”를 함께 적어야 합니다.

### 기본 템플릿

```markdown
---
name: Code Review Checklist
description: Review code changes for bugs, regressions, security risks, and missing tests. Use when the user asks for code review, PR review, diff review, or change risk analysis.
allowed-tools: Read, Grep, Glob
---

# Code Review Checklist

## Instructions

1. Review findings first, ordered by severity.
2. Focus on bugs, regressions, security, and test gaps.
3. Include file and line references when possible.
4. Do not spend primary attention on style preferences.

## Output Format

- Severity:
- File/Line:
- Problem:
- Why it matters:
- Suggested fix:
- Test gap:
```

`allowed-tools`는 Claude Code Skills에서 사용할 수 있으며, 해당 Skill이 활성화될 때 허용 도구를 제한하는 용도입니다. 읽기 전용 리뷰 Skill이라면 `Read, Grep, Glob`만 허용하는 식으로 안전성을 높일 수 있습니다.

### description 작성법

나쁜 예:

```yaml
description: Helps with code.
```

좋은 예:

```yaml
description: Review code diffs for bugs, security issues, regressions, and missing tests. Use when reviewing pull requests, git diffs, or recently changed files before merge.
```

트리거 단어를 구체적으로 넣어야 Claude가 Skill을 잘 발견합니다.

### 본문에 넣을 것

`SKILL.md` 본문에는 핵심 절차만 넣습니다.

- 작업 순서
- 판단 기준
- 출력 형식
- 금지사항
- 필요한 reference 파일 안내
- 스크립트 실행 방법

긴 API 문서나 정책 전문은 본문에 넣지 말고 `references/`로 분리합니다.

### 체크리스트

- [ ] frontmatter가 `---`로 시작하고 끝난다.
- [ ] `name`이 명확하다.
- [ ] `description`에 용도와 사용 시점이 모두 들어 있다.
- [ ] 본문은 핵심 절차 중심이다.
- [ ] 필요한 경우 `allowed-tools`로 도구 범위를 제한한다.

### 다음 단계

다음 장에서는 slash commands와 Skills의 차이와 최신 관계를 다룹니다.
