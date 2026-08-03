## 103. Windows PowerShell 주의사항

저자: AI_Innovation_Studio

Windows에서 Claude Code를 사용할 때는 PowerShell 문법을 기준으로 생각해야 합니다. 인터넷 예제는 macOS/Linux shell 기준인 경우가 많으므로, 명령 치환, 경로, 환경 변수, 삭제 명령을 그대로 복사하면 실패하거나 위험할 수 있습니다.

### 자주 다른 문법

| 목적 | PowerShell | Bash 계열 |
| --- | --- | --- |
| 현재 폴더 | `Get-Location` | `pwd` |
| 파일 목록 | `Get-ChildItem` | `ls` |
| 환경 변수 읽기 | `$env:NAME` | `$NAME` |
| 환경 변수 설정 | `$env:NAME='value'` | `export NAME=value` |
| 텍스트 검색 | `Select-String` | `grep` |
| 명령 위치 | `where.exe node` | `which node` |

### 경로 주의

PowerShell에서는 공백이나 한글이 있는 경로를 따옴표로 감싸는 습관이 필요합니다.

```powershell
Set-Location "C:\Users\me\OneDrive\바탕 화면\project"
```

스크립트나 문서에 경로를 남길 때는 현재 작업 폴더 기준 상대 경로를 우선 사용하세요.

### 자주 헷갈리는 변환

| Bash 예시 | PowerShell 예시 |
| --- | --- |
| `rm -rf dist` | `Remove-Item .\dist -Recurse -Force` |
| `cat file.txt` | `Get-Content .\file.txt` |
| `grep error app.log` | `Select-String -Path .\app.log -Pattern error` |
| `FOO=bar npm test` | `$env:FOO='bar'; npm test` |
| `cp -r a b` | `Copy-Item .\a .\b -Recurse` |

삭제나 이동 명령은 변환만 맞다고 안전한 것이 아닙니다. 실행 전에 절대 경로와 대상 개수를 확인하세요.

### 안전한 확인 패턴

파일을 바꾸기 전에 먼저 조회 명령으로 범위를 확인하세요.

```powershell
Get-ChildItem -LiteralPath ".\dist"
Resolve-Path ".\dist"
```

여러 파일을 다룰 때는 `-WhatIf`를 지원하는 명령인지 확인합니다.

```powershell
Remove-Item -LiteralPath ".\dist" -Recurse -WhatIf
```

### 삭제와 이동

삭제 명령은 가장 조심해야 합니다. Claude Code에게 파일 삭제를 맡길 때도 먼저 대상 경로를 확인하게 하세요.

```text
삭제하기 전에 삭제 대상의 절대 경로를 먼저 출력하고,
내가 승인하기 전에는 Remove-Item을 실행하지 마.
```

### Claude에게 줄 요청

```text
아래 명령 예시는 macOS/Linux 기준이다.
Windows PowerShell에서 안전하게 실행할 수 있는 형태로 바꿔줘.
삭제, 이동, 권한 변경 명령은 위험도를 표시하고 대체 확인 명령을 함께 제안해줘.
```

### 체크리스트

- [ ] 현재 터미널이 PowerShell인지 CMD인지 확인했다.
- [ ] 경로에 공백이나 한글이 있으면 따옴표를 사용했다.
- [ ] Bash 전용 문법을 PowerShell 문법으로 바꿨다.
- [ ] 삭제 명령은 실행 전 대상 경로를 확인했다.
- [ ] 명령 예시가 현재 프로젝트 루트 기준인지 확인했다.
- [ ] 대량 변경은 가능한 경우 `-WhatIf`나 dry run으로 먼저 확인했다.
