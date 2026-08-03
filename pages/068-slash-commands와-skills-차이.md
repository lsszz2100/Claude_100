## 068. slash commands와 skills 차이

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

slash command는 사용자가 직접 입력해 실행하는 명령이고, Skill은 Claude가 요청 맥락을 보고 필요할 때 사용할 수 있는 능력 패키지입니다.

2026년 05월 03일 기준 Claude Code 문서에서는 custom commands와 Skills의 관계가 가까워졌습니다. 기존 `.claude/commands/*.md` 파일은 계속 동작할 수 있고, `.claude/skills/name/SKILL.md`도 직접 호출 가능한 명령처럼 사용할 수 있습니다. 하지만 설계 관점에서는 Skills가 더 구조적입니다.

### 비교

| 항목 | slash command | Skill |
| --- | --- | --- |
| 호출 방식 | 사용자가 `/name` 입력 | Claude가 자동 선택하거나 직접 호출 |
| 구조 | 단일 Markdown 파일 중심 | 폴더 + `SKILL.md` + 지원 파일 |
| 반복 프롬프트 | 적합 | 적합 |
| 긴 참고 자료 | 불리함 | references로 분리 가능 |
| 스크립트/템플릿 포함 | 제한적 | scripts/templates/assets 구성 가능 |
| 팀 공유 | `.claude/commands/` | `.claude/skills/` 또는 플러그인 |

### command가 더 나은 경우

- 사용자가 명확히 눌러 실행하는 짧은 작업
- `git status` 요약처럼 단일 프롬프트면 충분한 작업
- 자동 활성화가 필요 없는 작업

예시:

```text
/dev-summary
```

### Skill이 더 나은 경우

- 작업 절차가 여러 단계다.
- 참고 문서나 템플릿이 있다.
- Claude가 상황에 맞춰 자동으로 떠올리면 좋다.
- 팀 표준으로 공유해야 한다.

예시:

```text
release-notes/
  SKILL.md
  templates/
    release-note.md
  references/
    changelog-style.md
```

### 마이그레이션 기준

기존 command가 길어지면 Skill로 옮깁니다.

```text
이 custom command를 Skill로 바꿔야 하는지 평가해줘.

기준:
1. 절차가 여러 단계인지
2. 참고 문서가 필요한지
3. 출력 템플릿이 반복되는지
4. 스크립트로 고정할 부분이 있는지
5. Claude가 자동으로 사용하면 좋은지
```

### 체크리스트

- [ ] 직접 실행만 필요하면 command로 충분하다.
- [ ] 자동 발견과 지원 파일이 필요하면 Skill을 쓴다.
- [ ] command가 길어지면 Skill로 분리한다.
- [ ] 팀 공유는 프로젝트 폴더에 둔다.
- [ ] 민감하거나 위험한 Skill은 도구 권한을 제한한다.

### 다음 단계

다음 장에서는 코드 리뷰 기준을 Skill로 패키징하는 예시를 다룹니다.
