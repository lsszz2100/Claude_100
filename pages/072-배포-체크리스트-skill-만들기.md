## 072. 배포 체크리스트 Skill 만들기

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

배포 체크리스트 Skill은 배포 전 반복 확인을 표준화합니다. 배포는 위험한 작업이므로 자동 실행보다 “검토와 차단 기준”을 우선 설계해야 합니다.

### 폴더 구조

```text
.claude/
  skills/
    deploy-checklist/
      SKILL.md
      references/
        environments.md
        rollback.md
```

### SKILL.md 예시

```markdown
---
name: Deployment Checklist
description: Prepare deployment readiness checks, risk review, rollback planning, and release verification. Use before staging or production deployments.
allowed-tools: Read, Grep, Glob
---

# Deployment Checklist

## Instructions

1. Do not run deployment commands.
2. Review changed files, migrations, config changes, and dependency updates.
3. Identify required tests and checks.
4. Confirm rollback or recovery plan.
5. Produce a go/no-go checklist.

## Required Checks

- Tests:
- Build:
- Database migrations:
- Environment variables:
- Feature flags:
- Monitoring:
- Rollback:
- Owner approval:

## Output Format

## Go/No-Go

- Decision:
- Blockers:

## Checklist

- [ ] Tests passed
- [ ] Migration reviewed
- [ ] Rollback plan ready
- [ ] Monitoring ready

## Risks

- [risk]
```

### 왜 실행 권한을 제한하는가

배포 Skill이 자동으로 `deploy`, `terraform apply`, `kubectl apply` 같은 명령을 실행하면 사고 가능성이 큽니다. 처음에는 읽기 전용 검토 Skill로 시작하고, 배포 실행은 별도 승인 절차로 분리합니다.

### 환경별 기준

배포 체크리스트는 환경별로 기준이 달라야 합니다.

| 환경 | 기준 |
| --- | --- |
| local | 실행 명령과 기본 테스트 확인 |
| staging | 실제 배포 절차, 마이그레이션, feature flag 확인 |
| production | 승인자, 롤백, 모니터링, 공지, 장애 대응 확인 |

처음 Skill을 만들 때는 production 배포를 자동화 대상으로 삼지 마세요. production은 읽기 전용 검토와 go/no-go 판단까지만 맡기는 것이 안전합니다.

### 차단 기준

다음 항목이 있으면 배포 보류로 판단하게 하세요.

- 실패한 테스트가 설명 없이 남아 있다.
- DB migration의 롤백 계획이 없다.
- 새 환경 변수나 secret 설정 방식이 불명확하다.
- 모니터링과 알림 기준이 없다.
- 배포 후 확인할 담당자가 없다.
- 사용자 영향이 큰 변경인데 공지나 대응 계획이 없다.

### 체크리스트

- [ ] 배포 명령을 자동 실행하지 않는다.
- [ ] migration과 환경 변수 변경을 확인한다.
- [ ] rollback 또는 recovery 계획이 있다.
- [ ] go/no-go 판단 형식이 있다.
- [ ] 승인자와 남은 blocker를 표시한다.
- [ ] 환경별 기준이 분리되어 있다.
- [ ] 배포 보류 조건이 명확하다.

### 다음 단계

다음 장에서는 Skill의 progressive disclosure 원리를 다룹니다.
