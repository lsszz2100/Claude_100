## 114. Docker 배포 예시

저자: AI_Innovation_Studio

Docker는 실행 환경을 고정해 로컬, CI, 운영의 차이를 줄이는 도구입니다. AI 앱에서는 환경 변수, 모델 API 키, 로그, 비용 설정을 이미지에 포함하지 않는 것이 중요합니다.

### Dockerfile 예시

```dockerfile
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

ENV NODE_ENV=production

CMD ["npm", "start"]
```

프로젝트에 빌드 단계가 있다면 의존성 설치, 빌드, 실행 이미지를 분리하는 방식도 고려합니다. 실행 이미지에는 소스 전체보다 실행에 필요한 산출물만 남기는 편이 관리하기 쉽습니다.

### 환경 변수 기준

AI 앱은 환경 변수 설계가 중요합니다. 값을 이미지에 넣지 말고 실행 환경에서 주입하세요.

| 구분 | 예시 | 관리 기준 |
| --- | --- | --- |
| 공개 설정 | `NODE_ENV`, 기능 플래그 | 저장소에 기본값 가능 |
| 비밀 설정 | API 키, OAuth secret | secret manager 또는 배포 환경 변수 |
| 운영 제한 | 요청당 최대 비용, 재시도 횟수 | 환경별로 다르게 설정 |
| 관찰 설정 | 로그 레벨, trace sampling | 운영 중 조절 가능하게 설계 |

### .dockerignore 예시

```text
node_modules
.git
.env
.env.*
dist
coverage
*.log
```

### 배포 전 확인

- [ ] API 키가 이미지에 포함되지 않는다.
- [ ] `.env` 파일이 빌드 컨텍스트에 들어가지 않는다.
- [ ] health check 또는 readiness check가 있다.
- [ ] 컨테이너가 종료 신호를 받으면 작업을 정리하고 종료한다.
- [ ] 로그는 표준 출력으로 남기고 파일에만 의존하지 않는다.
- [ ] 로그에 프롬프트와 민감 정보가 그대로 남지 않는다.
- [ ] 이미지 크기와 빌드 시간이 과도하지 않다.

### 로컬 검증 명령

배포 전에 같은 이미지로 실행과 종료를 확인하세요.

```text
docker build -t ai-app:local .
docker run --rm --env-file .env.local -p 3000:3000 ai-app:local
docker image ls ai-app
```

실제 secret이 들어 있는 `.env` 파일을 예시 명령에 넣지 마세요. 로컬 검증용 값과 운영 secret은 분리해야 합니다.

### Claude에게 줄 요청

```text
현재 프로젝트를 Docker로 배포하기 위한 계획을 작성해줘.

확인할 것:
1. 실행 명령
2. 필요한 환경 변수
3. Dockerfile 초안
4. .dockerignore 초안
5. 보안상 이미지에 포함하면 안 되는 파일
6. 로컬 검증 명령

아직 파일은 만들지 말고 계획만 작성해줘.
```

### 운영 팁

AI 앱은 코드만 배포하는 것이 아니라 프롬프트, 평가, 비용 제한, 모니터링까지 함께 운영해야 합니다. Dockerfile이 완성되어도 운영 준비가 끝난 것은 아닙니다.

Docker 배포가 처음이라면 먼저 로컬에서 같은 명령으로 세 번 실행해 보세요. 첫 실행만 성공하고 두 번째부터 실패한다면 캐시, 파일 권한, 포트 점유, 임시 파일 정리 문제가 숨어 있을 수 있습니다.

### 체크리스트

- [ ] 로컬에서 이미지 빌드와 실행을 확인했다.
- [ ] 운영 secret이 이미지와 로그에 포함되지 않는다.
- [ ] health check와 종료 처리를 확인했다.
