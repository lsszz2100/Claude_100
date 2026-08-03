## 108. 추천 Skill 템플릿

저자: AI_Innovation_Studio

Skill은 반복 가능한 작업 절차를 패키징하는 단위입니다. 좋은 Skill은 언제 써야 하는지, 어떤 자료를 읽어야 하는지, 어떤 형식으로 결과를 내야 하는지를 짧게 정의합니다.

Skill을 처음 만들 때는 “자주 반복하지만 매번 설명하기 귀찮은 작업”을 고르세요. 예를 들어 PR 리뷰 형식, 릴리스 노트 작성, 문서 점검, 테스트 실패 분석처럼 입력과 출력이 비교적 일정한 작업이 좋습니다.

반대로 매번 판단 기준이 크게 달라지는 작업, 위험한 권한이 필요한 작업, 한 번만 할 작업은 Skill로 만들기보다 일반 프롬프트로 처리하는 편이 낫습니다.

### SKILL.md 템플릿

````markdown
---
name: skill-name
description: Use when ...
---

# Skill Name

저자: AI_Innovation_Studio

## When To Use

Use this skill when ...

## Inputs

- Required:
- Optional:

## Workflow

1. Read the relevant files.
2. Identify constraints and risks.
3. Produce the requested output.
4. Include verification steps.

## Output Format

```text
Summary:

Findings:

Recommended next steps:
```

## Guardrails

- Do not invent facts not present in the source.
- Do not edit files unless explicitly requested.
- Call out missing context.
````

### Claude에게 줄 요청

```text
내가 자주 하는 다음 작업을 Skill로 만들고 싶다.

작업:
[작업 설명]

요청:
1. Skill이 필요한 상황을 정의해줘.
2. SKILL.md 초안을 작성해줘.
3. 참조 파일, scripts, templates가 필요한지 구분해줘.
4. 너무 복잡하면 첫 버전에서 제외할 항목을 제안해줘.
```

### 작성 순서

1. Skill을 호출해야 하는 상황을 한 문장으로 씁니다.
2. 반드시 읽어야 하는 파일과 읽지 않아도 되는 파일을 나눕니다.
3. 작업 순서를 네 단계 이하로 줄입니다. 첫 버전이 길면 유지보수가 어려워집니다.
4. 결과 형식을 고정합니다. 그래야 같은 작업을 반복해도 결과를 비교하기 쉽습니다.
5. 사실을 추정하지 말고 근거가 없는 부분은 “확인 필요”로 표시하게 합니다.

### 초보자가 많이 하는 실수

- description을 너무 넓게 써서 원하지 않는 상황에도 Skill이 호출된다.
- Skill 안에 여러 역할을 한꺼번에 넣는다.
- 검증 방법 없이 결과 형식만 정한다.
- 파일 수정 권한이 필요 없는 작업인데 수정까지 허용한다.

### 체크리스트

- [ ] description이 호출 조건을 분명히 설명한다.
- [ ] workflow가 실제 작업 순서를 반영한다.
- [ ] 출력 형식이 재사용 가능하다.
- [ ] 자동 실행이나 쓰기 권한이 불필요하게 넓지 않다.
