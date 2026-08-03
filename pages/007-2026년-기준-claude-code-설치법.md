## 007. 2026년 기준 Claude Code 설치법

난이도: 초급  
기준일: 2026년 05월 06일
저자: AI_Innovation_Studio

### 핵심 개념

Claude Code 설치법은 시간이 지나며 바뀝니다. 2026년 05월 06일 기준으로는 Claude Code 공식 문서의 한국어 개요와 고급 설정 문서를 우선해야 합니다. 현재 공식 문서는 Native Install을 권장 설치 방식으로 안내하고, Homebrew, WinGet, Linux 패키지 관리자, npm을 대체 경로로 함께 설명합니다.

따라서 과거 블로그나 예전 답변에서 본 설치 명령을 그대로 따라 하기보다, 먼저 공식 문서에서 자신의 운영체제와 터미널에 맞는 명령을 확인해야 합니다. `npm install -g @anthropic-ai/claude-code`는 여전히 가능한 설치 방식이지만, 기본 추천 경로는 Native Install입니다.

### 공식 설치 흐름

가장 먼저 선택할 방식은 Native Install입니다.

Windows PowerShell에서는 다음 명령을 사용합니다.

```powershell
irm https://claude.ai/install.ps1 | iex
```

Windows CMD에서는 PowerShell 명령이 아니라 CMD용 명령을 사용합니다.

```cmd
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

macOS, Linux, WSL에서는 다음 명령을 사용합니다.

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

WinGet을 사용할 수도 있습니다. 다만 WinGet 설치는 Claude Code 자체의 백그라운드 자동 업데이트 대상이 아니므로 주기적으로 업그레이드해야 합니다.

```powershell
winget install Anthropic.ClaudeCode
winget upgrade Anthropic.ClaudeCode
```

Homebrew 환경에서는 다음 방식도 가능합니다. Homebrew 설치도 자동 업데이트되지 않으므로 필요할 때 업그레이드합니다.

```bash
brew install --cask claude-code
brew upgrade claude-code
```

최신 릴리스를 바로 받고 싶다면 Homebrew에서 `claude-code@latest` cask를 선택할 수 있습니다. 안정성을 더 중시하면 일반 `claude-code` cask가 적합합니다.

Debian, Ubuntu, Fedora, RHEL, Alpine 같은 Linux 배포판에서는 공식 apt, dnf, apk 저장소를 통한 설치도 가능합니다. 조직이나 서버 환경에서는 이 방식이 버전 관리와 배포 정책에 더 잘 맞을 수 있습니다.

### 설치 전 확인할 것

Claude Code는 다음 조건을 요구합니다.

- macOS 13.0 이상
- Windows 10 1809 이상 또는 Windows Server 2019 이상
- Ubuntu 20.04 이상, Debian 10 이상, Alpine Linux 3.19 이상
- x64 또는 ARM64 프로세서
- 4GB 이상 RAM
- 인터넷 연결

인증에는 Claude Pro, Max, Team, Enterprise 또는 Anthropic Console 계정이 필요합니다. 무료 Claude.ai 플랜만으로는 Claude Code 접근이 포함되지 않을 수 있습니다. Terminal CLI와 VS Code 환경에서는 일부 타사 제공자도 사용할 수 있습니다.

### npm 설치에 대한 판단

공식 문서는 npm 설치도 고급 설치 옵션으로 안내합니다.

```bash
npm install -g @anthropic-ai/claude-code
```

다만 npm 방식은 Node.js 18 이상이 필요하고, 전역 패키지 경로, 권한, PATH 문제를 함께 관리해야 합니다. 초급자라면 Native Install, WinGet, Homebrew, Linux 패키지 관리자 중 하나를 먼저 선택하는 편이 단순합니다.

### 설치 후 첫 실행

프로젝트 폴더로 이동한 뒤 `claude`를 실행합니다.

```bash
cd your-project
claude
```

첫 실행 시 로그인 또는 인증 절차가 나타납니다. 이후 Claude Code는 현재 프로젝트를 기준으로 작업을 시작합니다.

설치 상태는 다음 명령으로 확인합니다.

```bash
claude --version
claude doctor
```

### Windows에서 주의할 점

PowerShell과 CMD는 명령 문법이 다릅니다. PowerShell 프롬프트는 보통 `PS C:\...`처럼 보이고, CMD는 `C:\...`처럼 보입니다. PowerShell에서 CMD용 명령을 그대로 붙여넣으면 오류가 날 수 있습니다.

PowerShell에서 `&&` 구문 오류가 보이면 CMD용 명령을 PowerShell에서 실행한 것입니다. CMD에서 `irm`을 인식하지 못하면 PowerShell용 명령을 CMD에서 실행한 것입니다. 먼저 현재 터미널을 확인한 뒤 맞는 명령을 사용하세요.

native Windows 환경에서는 Git for Windows 설치가 권장됩니다. Git for Windows가 있으면 Claude Code가 Bash 도구를 더 자연스럽게 사용할 수 있습니다. Git for Windows가 없다면 Claude Code는 PowerShell을 셸 도구로 사용할 수 있습니다. WSL 환경이라면 Git for Windows가 필수는 아닙니다.

WSL에서 사용할 경우 PowerShell이나 CMD가 아니라 WSL 터미널 안에서 Linux 설치 명령을 실행해야 합니다.

### 실습

아직 설치하지 않았다면, 먼저 공식 문서를 확인한 뒤 자신의 환경에 맞는 설치 명령을 하나만 선택하세요. 이미 설치했다면 다음 명령으로 상태를 확인합니다.

```bash
claude --version
claude doctor
```

또는 Claude Code 안에서 상태 명령을 확인합니다.

```text
/status
```

### Claude에게 입력할 프롬프트

```text
내 운영체제는 [Windows/macOS/Linux/WSL]이다.
2026년 기준 Claude Code를 설치하려고 한다.

다음을 확인해줘.
1. 내 환경에서 추천되는 설치 방식
2. 설치 전 확인할 것
3. 설치 후 확인 명령
4. 흔한 오류와 해결법
5. Native Install, WinGet, Homebrew, npm 중 무엇을 선택해야 하는지
```

### 체크리스트

- [ ] 설치 정보는 공식 문서를 우선한다.
- [ ] Windows에서는 PowerShell과 CMD 명령을 구분한다.
- [ ] 설치 후 `claude` 실행을 확인한다.
- [ ] `claude --version`과 `claude doctor`로 설치 상태를 확인한다.
- [ ] npm 설치는 가능한 선택지지만 기본 권장 경로가 아님을 이해한다.
- [ ] WinGet과 Homebrew 설치는 수동 업그레이드가 필요함을 이해한다.

### 다음 단계

다음 장에서는 Windows 사용자를 위한 Claude Code 시작 흐름을 더 자세히 다룹니다.
