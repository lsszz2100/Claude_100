## 086. Database MCP

난이도: 고급  
기준일: 2026년 05월 03일
저자: AI_Innovation_Studio

### 핵심 개념

Database MCP는 Claude가 데이터베이스에 질의할 수 있게 하는 강력한 연결입니다. 가장 중요한 원칙은 읽기 전용, 최소 권한, 샌드박스, 감사 로그입니다.

운영 DB에 쓰기 권한을 가진 MCP를 바로 연결하는 것은 피해야 합니다.

### 안전한 기본 정책

```text
Database MCP 정책:
- 기본은 read-only 계정 사용
- production DB 직접 연결 금지
- 가능하면 replica 또는 anonymized snapshot 사용
- PII 컬럼 마스킹
- 쿼리 row limit 강제
- DDL/DML 차단
- 모든 쿼리 로그 기록
```

### 계정과 네트워크 기준

DB MCP를 연결할 때는 계정 권한과 네트워크 경계를 함께 봐야 합니다.

| 항목 | 권장 기준 |
| --- | --- |
| 계정 | read-only 전용 계정 |
| 환경 | production 직접 연결 금지 |
| 네트워크 | 사내망, VPN, allowlist 등 제한 |
| 데이터 | anonymized snapshot 또는 replica 우선 |
| 결과 | 집계값 우선, 원본 PII 출력 금지 |
| 제한 | row limit, timeout, query allowlist |

운영 DB에 직접 붙는 MCP는 편리함보다 사고 가능성이 큽니다. 분석 목적이라면 복제본이나 익명화된 스냅샷을 기본으로 삼으세요.

### 좋은 요청 예시

```text
Database MCP로 사용자 활동 통계를 조회해줘.

제약:
- SELECT만 사용해줘.
- LIMIT 100을 넘지 마.
- 이메일, 전화번호, 이름 같은 개인정보는 출력하지 마.
- 먼저 실행할 SQL을 보여주고 승인 후 실행해줘.
```

### 위험한 요청

```text
운영 DB에서 오래된 사용자 삭제해줘.
```

이런 작업은 MCP가 아니라 별도 migration/runbook/승인 절차가 필요합니다.

### 쿼리 검토 템플릿

```text
아래 DB 쿼리를 실행하기 전에 검토해줘.

확인할 것:
1. SELECT만 사용하는지
2. 개인정보가 출력되는지
3. LIMIT이 있는지
4. 테이블 scan 위험
5. 운영 DB에서 실행해도 되는지
6. 더 안전한 대안
```

### 권장 작업 순서

Database MCP 작업은 다음 순서로 진행하는 편이 안전합니다.

1. 질문을 SQL로 바로 실행하지 않고 필요한 데이터 범위를 먼저 정의한다.
2. 사용할 테이블과 컬럼을 확인한다.
3. 개인정보나 민감 컬럼이 포함되는지 검토한다.
4. 실행할 SQL 초안을 만든다.
5. LIMIT, timeout, read-only 조건을 확인한다.
6. 승인 후 실행한다.
7. 결과를 요약하고 원본 민감값은 출력하지 않는다.

### 위험 신호

| 신호 | 대응 |
| --- | --- |
| `DELETE`, `UPDATE`, `INSERT`가 필요함 | MCP가 아니라 migration/runbook으로 분리 |
| 운영 DB 직접 연결 | replica, snapshot, staging 우선 |
| PII 컬럼 조회 | 마스킹 또는 집계값으로 대체 |
| LIMIT 없는 쿼리 | row limit 강제 |
| 느린 테이블 scan 가능성 | explain 또는 DBA 검토 |

### 로그와 감사

DB MCP는 모든 쿼리와 결과 범위를 기록해야 합니다. 단, 결과 원문 전체를 로그로 남기면 또 다른 민감 정보 저장소가 됩니다.

남길 것:

- 실행 시간
- 실행 사용자 또는 세션
- 쿼리 유형
- 접근한 테이블
- 반환 row 수
- 차단 여부

남기지 말 것:

- 개인정보 원문
- 인증 정보
- 고객 데이터 전문
- 대량 결과 전체

### 분석 요청 예시

```text
Database MCP로 결제 전환율을 분석하고 싶다.

먼저 실행 계획만 작성해줘.

조건:
- SELECT만 사용
- 개인정보 컬럼 출력 금지
- 집계 결과만 출력
- LIMIT 또는 기간 조건 필수
- 실행할 SQL은 승인 전까지 실행하지 않기
```

### 체크리스트

- [ ] read-only 계정으로 연결한다.
- [ ] production 직접 연결을 피한다.
- [ ] PII 출력 금지 규칙이 있다.
- [ ] LIMIT과 timeout을 강제한다.
- [ ] 쿼리 실행 전 SQL 초안을 검토한다.
- [ ] 쿼리 로그에 민감 원문을 남기지 않는다.
- [ ] 분석용 replica 또는 snapshot 사용을 우선한다.

### 다음 단계

다음 장에서는 Filesystem MCP를 안전하게 범위 제한하는 방법을 다룹니다.
