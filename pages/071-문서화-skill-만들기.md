## 071. 문서화 Skill 만들기

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

문서화 Skill은 README, API 문서, 운영 가이드, 릴리스 노트처럼 반복되는 문서 작성 기준을 재사용하게 합니다. 핵심은 “코드 근거 없이 추정하지 않기”와 “독자에 맞는 출력 형식”입니다.

### 폴더 구조

```text
.claude/
  skills/
    docs-writer/
      SKILL.md
      templates/
        api-doc.md
        runbook.md
      references/
        writing-style.md
```

### SKILL.md 예시

```markdown
---
name: Documentation Writer
description: Create and review project documentation based on current code, configuration, and tests. Use for README updates, API docs, runbooks, onboarding guides, and release notes.
allowed-tools: Read, Grep, Glob
---

# Documentation Writer

## Instructions

1. Identify the target audience before writing.
2. Read relevant source files, config, and tests before drafting.
3. Mark unsupported claims as "확인 필요".
4. Do not include secrets, tokens, or customer data.
5. End with source files used as evidence.

## Document Types

- README: setup, run, test, build, troubleshooting.
- API docs: endpoint, auth, request, response, errors.
- Runbook: symptoms, checks, commands, rollback.
- Release notes: user impact, migration notes, known issues.

## Output Requirements

- Audience:
- Purpose:
- Steps:
- Verification:
- Source files:
```

### 템플릿 분리

긴 문서 형식은 `templates/`로 분리합니다.

```text
templates/
  api-doc.md
  runbook.md
  release-note.md
```

`SKILL.md`에는 어떤 상황에서 어떤 템플릿을 사용할지만 적습니다.

### 문서 유형별 근거

문서화 Skill은 쓰기 전에 무엇을 읽어야 하는지 정해야 합니다.

| 문서 유형 | 먼저 확인할 파일 |
| --- | --- |
| README | package 파일, 실행 스크립트, 환경 변수 예시 |
| API 문서 | 라우터, 컨트롤러, 스키마, 테스트 |
| 운영 가이드 | 배포 설정, 로그, 모니터링, 장애 대응 문서 |
| 릴리스 노트 | git diff, PR, issue, 마이그레이션 |
| 온보딩 문서 | 폴더 구조, 개발 명령, 테스트 명령 |

근거를 읽지 못한 부분은 단정하지 말고 “확인 필요”로 표시합니다. 문서가 친절해도 실제 코드와 맞지 않으면 운영에서는 위험합니다.

### 리뷰 요청 예시

```text
방금 작성한 문서를 현재 코드 기준으로 검토해줘.

확인할 것:
1. 코드와 맞지 않는 설명
2. 누락된 실행 명령
3. 위험한 보안 표현
4. 초급자가 막힐 수 있는 단계
5. 추가로 읽어야 할 파일
```

### 체크리스트

- [ ] 독자와 목적을 먼저 확인한다.
- [ ] 코드와 설정 파일을 근거로 작성한다.
- [ ] 문서 유형별 템플릿을 분리한다.
- [ ] 비밀정보를 포함하지 않는다.
- [ ] 근거 파일 목록을 남긴다.
- [ ] 확인하지 못한 내용은 단정하지 않는다.
- [ ] 문서 검토용 요청 문장을 함께 둔다.

### 다음 단계

다음 장에서는 배포 전 점검을 Skill로 만드는 방법을 다룹니다.
