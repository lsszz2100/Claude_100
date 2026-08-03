## 115. CI/CD 자동화 예시

저자: AI_Innovation_Studio

CI/CD는 테스트, 빌드, 보안 검사, 배포를 반복 가능하게 만드는 장치입니다. Claude Code와 함께 사용할 때는 실패 로그를 읽고 원인을 좁히는 흐름까지 자동화할 수 있습니다.

### 기본 파이프라인

```text
checkout -> install -> lint -> test -> build -> security check -> deploy
```

CI와 CD는 분리해서 생각하는 편이 안전합니다. CI는 모든 PR에서 반복 실행되는 검증이고, CD는 검증된 결과를 특정 환경에 반영하는 절차입니다. 처음부터 자동 배포까지 연결하기보다 테스트와 빌드가 안정된 뒤 배포 승인을 붙이세요.

### GitHub Actions 예시

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
      - run: npm ci
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

### Claude에게 줄 요청

```text
현재 프로젝트에 맞는 CI 파이프라인을 설계해줘.

확인할 것:
1. 패키지 매니저
2. lint 명령
3. test 명령
4. build 명령
5. 캐시 전략
6. 실패했을 때 읽어야 할 로그 위치

보안상 secret 출력 위험도 함께 검토해줘.
```

### 배포 게이트

배포 전에 자동으로 확인할 항목과 사람이 승인할 항목을 나누세요.

| 구분 | 예시 |
| --- | --- |
| 자동 확인 | 테스트 통과, 빌드 성공, 린트 통과, 취약점 검사 |
| 사람이 확인 | 마이그레이션 영향, 비용 증가, 외부 API 권한 변경 |
| 배포 후 확인 | health check, 오류율, 지연 시간, 비용 급증 |

AI 기능은 프롬프트나 모델 설정만 바뀌어도 동작이 달라질 수 있습니다. 코드 변경이 작아 보여도 평가셋 재실행 여부를 확인해야 합니다.

### 캐시와 재현성

CI 속도를 높이려고 캐시를 쓰더라도 재현성을 잃으면 안 됩니다.

| 항목 | 기준 |
| --- | --- |
| 의존성 | lockfile 기반 설치 |
| 캐시 키 | lockfile과 런타임 버전 포함 |
| 테스트 데이터 | CI에서 생성하거나 고정 fixture 사용 |
| secret | PR 로그와 artifact에 출력 금지 |
| artifact | 보관 기간과 접근 권한 제한 |

캐시 문제로 실패가 흔들리면 먼저 캐시를 비우고 재현되는지 확인하세요.

### 실패 로그 분석 요청

```text
아래 CI 로그를 분석해줘.

요청:
1. 최초 실패 원인
2. 파생 오류
3. 가장 작은 수정 후보
4. 재실행해야 할 명령
5. 관련 파일 후보

로그:
[붙여넣기]
```

### 체크리스트

- [ ] PR마다 테스트가 실행된다.
- [ ] main 배포 전 최소 검증이 있다.
- [ ] secret이 로그에 출력되지 않는다.
- [ ] 실패 원인을 추적할 수 있는 로그가 남는다.
- [ ] 배포와 검증 결과를 같은 PR 또는 릴리스 기록에 남긴다.
- [ ] 프롬프트와 평가셋 변경도 CI 검토 대상에 포함한다.
- [ ] 캐시가 재현성을 해치지 않는지 확인했다.
