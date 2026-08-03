## 102. Claude Code 설치 문제 해결

저자: AI_Innovation_Studio

설치 문제는 대부분 터미널 종류, PATH 설정, 네트워크 접근, 계정 인증, 운영체제/아키텍처 지원 범위 중 하나에서 발생합니다. npm으로 설치한 경우에는 Node.js와 전역 패키지 경로 문제도 함께 봐야 하지만, Native Install이나 WinGet, Homebrew로 설치했다면 Node.js부터 확인할 필요는 없습니다. 오류 메시지를 바로 복사하기 전에 환경 정보를 먼저 정리하면 해결 속도가 빨라집니다.

### 먼저 확인할 것

```text
claude --version
claude doctor
where claude
```

macOS나 Linux에서는 `where` 대신 `which`를 사용할 수 있습니다.

```text
which claude
```

npm 방식으로 설치했다면 그때만 Node.js와 npm도 함께 확인합니다.

```text
node --version
npm --version
where node
where npm
```

### 흔한 원인

| 증상 | 확인할 지점 |
| --- | --- |
| 명령을 찾을 수 없음 | PATH 등록, 터미널 재시작 |
| `irm` 또는 `&&` 오류 | PowerShell/CMD 명령 혼동 |
| 설치 권한 오류 | 설치 방식, 사용자 권한, 보안 프로그램 |
| 다운로드 실패 | 프록시, 회사망, 방화벽, DNS, `downloads.claude.ai` 접근 |
| 실행 후 인증 실패 | 계정 로그인, 토큰, 브라우저 인증 |
| `claude`가 예전 버전으로 실행됨 | 여러 설치 방식 혼재, PATH 우선순위 |
| 프로젝트에서만 실패 | 현재 폴더 권한, 보안 프로그램, 긴 경로 |

### 진단 순서

설치 문제는 한 번에 고치려고 하지 말고 범위를 좁히세요.

1. 새 터미널을 열고 `claude --version`을 확인한다.
2. `claude doctor`로 설치와 설정 상태를 확인한다.
3. Windows라면 PowerShell과 CMD 중 어느 터미널에서 실행 중인지 확인한다.
4. `where claude` 또는 `which claude`로 실제 실행 경로를 확인한다.
5. 회사망이나 프록시 환경이라면 다운로드 차단 여부를 확인한다.
6. 설치 방식이 Native Install, WinGet, Homebrew, npm 중 무엇인지 확인한다.
7. 프로젝트 폴더가 OneDrive, 네트워크 드라이브, 권한 제한 폴더인지 확인한다.

문제가 시스템 전체인지 특정 프로젝트인지 구분하려면 빈 폴더에서 같은 명령을 실행해 보세요.

다운로드 서버 접근이 의심되면 다음처럼 연결성을 확인합니다.

```bash
curl -sI https://downloads.claude.ai/claude-code-releases/latest
```

응답이 없거나 DNS/SSL 오류가 나면 회사 방화벽, 프록시, 인증서, VPN 환경을 먼저 확인하세요.

### 환경 정보 템플릿

설치 문제를 요청할 때는 다음 정보를 먼저 모으세요.

```text
OS:
터미널:
설치 방식:
실행한 명령:
claude --version:
claude doctor 결과:
where/which claude:
전체 오류 메시지:
회사망/프록시 여부:
프로젝트 경로:
```

npm 설치를 사용한 경우에만 다음도 추가합니다.

```text
node --version:
npm --version:
where/which node:
where/which npm:
```

경로에 사용자 이름, 이메일, 내부 도메인, 토큰이 들어 있다면 공유 전에 가립니다.

### Claude에게 줄 진단 요청

```text
Claude Code 설치가 실패했다.

환경:
- OS:
- 터미널:
- 설치 방식:
- claude --version:
- claude doctor 결과:
- where/which claude:
- 설치 명령:
- 오류 메시지:

요청:
1. 가능한 원인을 우선순위로 정리해줘.
2. 위험하지 않은 확인 명령부터 제안해줘.
3. 관리자 권한이나 삭제 명령이 필요한 단계는 별도 승인 단계로 분리해줘.
```

### 주의할 점

- 오류 메시지에 토큰, 이메일, 내부 URL이 있으면 가린 뒤 공유한다.
- 설치 문제를 해결하려고 임의로 시스템 폴더를 삭제하지 않는다.
- 회사 장비에서는 프록시와 보안 정책을 먼저 확인한다.
- Native Install, WinGet, Homebrew, npm 설치가 섞이면 어느 경로의 명령이 실행되는지 확인한다.
- 오래된 설치 흔적을 지우기 전에는 삭제 대상 경로를 먼저 확인한다.

### Windows에서 추가 확인

- OneDrive나 네트워크 드라이브보다 짧은 로컬 경로에서 재현해 본다.
- PowerShell용 명령과 CMD용 명령을 혼동하지 않았는지 확인한다.
- `where.exe claude`로 여러 Claude Code 설치가 섞였는지 확인한다.
- Git for Windows가 없을 때는 Claude Code가 PowerShell 셸 도구를 사용한다는 점을 이해한다.
- WSL에서는 PowerShell이나 CMD가 아니라 WSL 터미널 안에서 설치하고 실행한다.
- npm 설치를 사용한 경우에만 `where.exe node`와 `where.exe npm`으로 여러 Node 설치가 섞였는지 확인한다.

### 완료 기준

- [ ] `claude` 명령이 실행된다.
- [ ] `claude doctor` 또는 상태 점검 명령에서 치명 오류가 없다.
- [ ] 새 프로젝트 폴더에서 첫 세션을 열 수 있다.
- [ ] 설치 방법과 오류 해결 과정을 메모했다.
- [ ] 같은 오류가 재발했을 때 볼 수 있는 진단 기록이 있다.
