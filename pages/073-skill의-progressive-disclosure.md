## 073. Skill의 progressive disclosure

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

progressive disclosure는 필요한 정보만 단계적으로 로드하는 설계 원칙입니다. Skill에서는 `description`이 항상 보이고, `SKILL.md` 본문은 Skill이 활성화될 때 읽히며, references/scripts/templates는 필요할 때만 사용됩니다.

이 구조 덕분에 긴 문서와 스크립트를 Skill에 포함해도 매번 전체 컨텍스트를 차지하지 않습니다.

### 세 단계

| 단계 | 내용 | 언제 로드되는가 |
| --- | --- | --- |
| Metadata | `name`, `description` | 항상 탐색에 사용 |
| SKILL.md body | 핵심 절차 | Skill 사용 시 |
| Supporting files | references, scripts, templates | 필요할 때 |

### 나쁜 설계

```text
SKILL.md 안에 다음을 전부 넣음:
- 회사 정책 전문
- API 문서 전체
- 예제 30개
- 스크립트 코드 전체
- 템플릿 전체
```

이렇게 하면 Skill이 활성화될 때 불필요한 내용까지 한꺼번에 들어옵니다.

### 좋은 설계

```text
deploy-skill/
  SKILL.md
  references/
    aws.md
    gcp.md
    rollback.md
  scripts/
    check_env.py
  templates/
    release-note.md
```

`SKILL.md`에는 선택 기준만 둡니다.

```markdown
## Provider Selection

- For AWS deployment review, read `references/aws.md`.
- For GCP deployment review, read `references/gcp.md`.
- For rollback planning, read `references/rollback.md`.
```

### 본문에 남길 것

- Skill의 목적
- 언제 사용할지
- 첫 단계
- 어떤 reference를 언제 읽을지
- 출력 형식
- 금지사항

### references로 분리할 것

- 긴 정책 문서
- API 상세 명세
- 프레임워크별 예시
- 회사별 템플릿
- 드문 edge case

### 파일을 나누는 기준

supporting file을 많이 만든다고 좋은 Skill이 되는 것은 아닙니다. 나누는 기준은 “항상 필요한가”와 “상황별로 달라지는가”입니다.

| 내용 | 위치 |
| --- | --- |
| 항상 필요한 절차 | `SKILL.md` |
| 출력 형식 | `SKILL.md` 또는 `templates/` |
| 특정 프레임워크 지침 | `references/` |
| 긴 예시 | `references/` |
| 실행 가능한 반복 검사 | `scripts/` |
| 문서 골격 | `templates/` |

`SKILL.md`에는 파일 목록을 늘어놓기보다 언제 어떤 파일을 읽어야 하는지 조건을 적으세요.

### 검증 방법

Skill을 만든 뒤에는 세 가지 요청으로 테스트합니다.

1. Skill이 꼭 필요한 요청
2. Skill이 필요 없는 비슷한 요청
3. reference를 읽어야 하는 특수 요청

이 세 요청에서 Skill이 과하게 호출되거나 필요한 reference를 읽지 못하면 `description`과 파일 선택 기준을 고쳐야 합니다.

### 체크리스트

- [ ] `SKILL.md`는 핵심 절차만 담는다.
- [ ] 긴 정보는 references로 분리한다.
- [ ] reference 파일을 언제 읽을지 명확히 적는다.
- [ ] 같은 내용을 본문과 reference에 중복하지 않는다.
- [ ] Skill이 너무 넓으면 여러 Skill로 나눈다.
- [ ] Skill이 필요 없는 요청에서 과하게 호출되지 않는다.
- [ ] supporting file을 읽는 조건을 테스트했다.

### 다음 단계

다음 장에서는 쓸모없거나 위험한 Skill을 제거하는 기준을 다룹니다.
