param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $Force) {
  Write-Host "This script rewrites README.md, TOC.md, and pages/. Run with -Force only when intentionally regenerating the scaffold."
  exit 1
}
$bookTitle = "Claude 기초부터 고급까지 100"
$author = "AI_Innovation_Studio"
$date = "2026년 05월 03일"

$topics = @(
  @{N=1; Level="초급"; Part="Part 01. Claude 입문"; Title="Claude란 무엇인가"; Focus="Claude를 단순 챗봇이 아니라 사고, 작성, 분석, 실행을 돕는 AI 작업 파트너로 이해한다."; Practice="Claude에게 자기소개, 문서 요약, 아이디어 확장, 코드 설명을 각각 요청해 차이를 비교한다."},
  @{N=2; Level="초급"; Part="Part 01. Claude 입문"; Title="Claude와 ChatGPT의 차이"; Focus="모델보다 중요한 것은 인터페이스, 도구, 컨텍스트, 실행 권한이라는 점을 이해한다."; Practice="같은 요청을 일반 대화형 AI와 Claude Code식 요청으로 나누어 작성한다."},
  @{N=3; Level="초급"; Part="Part 01. Claude 입문"; Title="챗봇과 에이전트의 차이"; Focus="챗봇은 답하고, 에이전트는 읽고 계획하고 실행하고 검증한다는 차이를 익힌다."; Practice="하나의 업무를 대화형 요청과 에이전트형 요청으로 바꾸어 본다."},
  @{N=4; Level="초급"; Part="Part 01. Claude 입문"; Title="Claude 생태계 전체 지도"; Focus="Claude Web, Desktop, Code, API, MCP, Skills, Agent SDK가 어떤 관계인지 파악한다."; Practice="내가 사용할 표면을 학습, 개발, 자동화, 운영으로 분류한다."},
  @{N=5; Level="초급"; Part="Part 01. Claude 입문"; Title="Claude Code란 무엇인가"; Focus="Claude Code가 터미널에서 코드베이스를 읽고 수정하고 명령을 실행하는 방식으로 동작함을 이해한다."; Practice="기존 프로젝트에서 '이 프로젝트가 무엇인지 설명해줘'라는 첫 요청을 설계한다."},
  @{N=6; Level="초급"; Part="Part 01. Claude 입문"; Title="Claude Web, Desktop, CLI, IDE 차이"; Focus="작업 환경별 강점과 한계를 구분한다."; Practice="문서 작업, 코드 수정, 장기 작업, 시각적 diff 검토에 맞는 환경을 선택한다."},
  @{N=7; Level="초급"; Part="Part 01. Claude 입문"; Title="2026년 기준 Claude Code 설치법"; Focus="2026년 05월 03일 기준 공식 설치 흐름과 deprecated 설치법을 구분한다."; Practice="Windows PowerShell, WinGet, macOS/Linux 설치 명령을 노트에 정리한다."},
  @{N=8; Level="초급"; Part="Part 01. Claude 입문"; Title="Windows에서 Claude Code 시작하기"; Focus="PowerShell, CMD, Git for Windows, WSL의 차이를 알고 Windows에서 안전하게 시작한다."; Practice="PowerShell 프롬프트와 CMD 프롬프트를 구분하고 설치 명령을 선택한다."},
  @{N=9; Level="초급"; Part="Part 01. Claude 입문"; Title="첫 Claude Code 세션 열기"; Focus="프로젝트 폴더에서 `claude`를 실행하고 첫 질문을 던지는 흐름을 익힌다."; Practice="새 폴더에서 Claude Code를 열고 프로젝트 요약을 요청한다."},
  @{N=10; Level="초급"; Part="Part 01. Claude 입문"; Title="프로젝트 폴더 이해시키기"; Focus="Claude가 파일 구조, README, 설정 파일, 테스트 파일을 읽으며 프로젝트 모델을 세우는 과정을 이해한다."; Practice="폴더 구조, 기술 스택, 실행 방법, 핵심 파일을 요약하게 한다."},
  @{N=11; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="좋은 질문과 나쁜 질문"; Focus="모호한 요청과 실행 가능한 요청의 차이를 배운다."; Practice="'좋게 만들어줘'를 목표, 범위, 제약이 있는 요청으로 고친다."},
  @{N=12; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="프롬프트의 4요소: 역할, 목표, 맥락, 제약"; Focus="역할, 목표, 맥락, 제약을 조합하면 결과 품질이 안정된다는 원리를 익힌다."; Practice="하나의 업무 요청을 4요소 템플릿으로 다시 작성한다."},
  @{N=13; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="결과 형식 지정하기"; Focus="표, 체크리스트, JSON, 단계별 설명처럼 출력 형식을 직접 지정하는 법을 배운다."; Practice="같은 내용을 표, 요약문, JSON으로 각각 출력하게 한다."},
  @{N=14; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="예시 기반 프롬프트"; Focus="원하는 결과 예시를 주면 Claude가 스타일과 구조를 더 안정적으로 맞춘다."; Practice="좋은 예시 1개와 나쁜 예시 1개를 제공해 결과 차이를 관찰한다."},
  @{N=15; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="단계별 작업 지시"; Focus="큰 요청을 탐색, 계획, 실행, 검증으로 나누는 법을 익힌다."; Practice="버그 수정 요청을 4단계 작업 지시로 바꾼다."},
  @{N=16; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="Claude에게 설명시키는 법"; Focus="학습용 설명, 코드 설명, 결정 이유 설명을 구분한다."; Practice="낯선 코드 파일을 초급자용, 실무자용, 리뷰어용으로 설명하게 한다."},
  @{N=17; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="Claude에게 비교시키는 법"; Focus="도구, 라이브러리, 설계안을 비교할 때 평가 기준을 먼저 정해야 한다."; Practice="두 기술 선택지를 비용, 난이도, 유지보수, 위험 기준으로 비교하게 한다."},
  @{N=18; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="Claude에게 검토시키는 법"; Focus="검토는 칭찬보다 결함, 위험, 누락, 테스트 공백을 찾는 작업임을 이해한다."; Practice="작은 코드 diff를 버그, 보안, 테스트 관점으로 검토하게 한다."},
  @{N=19; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="Claude에게 계획시키는 법"; Focus="바로 구현하지 않고 먼저 계획을 만들게 하는 습관을 익힌다."; Practice="기능 개발 요청에 대해 구현 전 계획만 작성하게 한다."},
  @{N=20; Level="초급"; Part="Part 02. 프롬프트 기초"; Title="Plan Mode 기초"; Focus="복잡한 작업에서는 계획 승인 후 실행하는 방식이 안전하다는 점을 배운다."; Practice="`/plan`을 사용할 상황과 사용하지 않을 상황을 구분한다."},
  @{N=21; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="/help, /clear, /compact, /cost"; Focus="기본 slash command로 세션, 컨텍스트, 비용을 관리한다."; Practice="각 명령의 목적과 사용 시점을 표로 정리한다."},
  @{N=22; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="파일 읽기와 코드베이스 요약"; Focus="Claude Code가 필요한 파일을 찾아 읽고 요약하게 만드는 법을 익힌다."; Practice="README, package 파일, src 폴더를 기준으로 프로젝트 설명을 요청한다."},
  @{N=23; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="작은 버그 고치기"; Focus="작은 범위의 문제를 재현, 원인 분석, 수정, 검증 순서로 처리한다."; Practice="오류 메시지 하나를 붙여넣고 원인 후보와 수정 계획을 요청한다."},
  @{N=24; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="테스트 실행 요청하기"; Focus="수정 후 테스트를 실행하고 실패를 읽어 다시 고치는 반복을 배운다."; Practice="테스트 명령을 찾아 실행하고 실패 요약을 요청한다."},
  @{N=25; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="Git 변경사항 확인하기"; Focus="수정된 파일과 diff를 확인한 뒤 다음 행동을 결정한다."; Practice="`git diff` 기준으로 변경 요약과 위험도를 작성하게 한다."},
  @{N=26; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="커밋 메시지 작성시키기"; Focus="변경 의도와 범위를 반영한 커밋 메시지 작성법을 익힌다."; Practice="diff를 바탕으로 Conventional Commit 형식의 메시지를 생성한다."},
  @{N=27; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="README 요약시키기"; Focus="문서에서 설치, 실행, 테스트, 배포 정보를 추출한다."; Practice="README를 신규 팀원용 10줄 요약으로 바꾼다."},
  @{N=28; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="비개발자를 위한 Claude Code 활용"; Focus="코딩 지식이 적어도 파일 정리, 문서 분석, 자동화 도구 제작에 활용할 수 있음을 이해한다."; Practice="개인 문서 폴더를 정리하는 요청을 작성한다."},
  @{N=29; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="학습자용 Claude 사용법"; Focus="정답을 복사하는 대신 설명, 힌트, 연습문제를 요청하는 학습법을 익힌다."; Practice="Claude에게 답을 주지 말고 힌트만 주도록 요청한다."},
  @{N=30; Level="초급"; Part="Part 03. Claude Code 기본 명령"; Title="초급자가 피해야 할 실수"; Focus="무작정 전체 수정, 테스트 생략, 권한 무비판 승인, 비밀정보 노출을 피한다."; Practice="초급자 안전 체크리스트를 만든다."},
  @{N=31; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="CLAUDE.md의 역할"; Focus="CLAUDE.md가 프로젝트의 장기 지침과 팀 규칙을 담는 파일임을 이해한다."; Practice="프로젝트 목적, 실행 명령, 코딩 규칙을 담은 CLAUDE.md 초안을 작성한다."},
  @{N=32; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="프로젝트 메모리 설계"; Focus="자동으로 로드될 정보와 필요할 때만 읽을 정보를 분리한다."; Practice="항상 필요한 규칙 10개와 필요 시 참조할 문서 5개를 나눈다."},
  @{N=33; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="개인 메모리와 팀 메모리"; Focus="개인 선호와 팀 표준이 섞이면 협업이 어려워진다는 점을 이해한다."; Practice="개인용 지침과 저장소용 지침을 분리한다."},
  @{N=34; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="디렉터리별 CLAUDE.md"; Focus="특정 하위 폴더에만 적용할 규칙을 지역화한다."; Practice="api, ui, tests 폴더별 지침 예시를 만든다."},
  @{N=35; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title=".claudeignore로 컨텍스트 절약"; Focus="빌드 산출물, 의존성, 로그, 대용량 파일을 제외해 컨텍스트 낭비를 줄인다."; Practice=".claudeignore 후보 목록을 만든다."},
  @{N=36; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="PRD.md 작성법"; Focus="제품 요구사항을 목표, 사용자, 범위, 비범위, 수용 기준으로 정리한다."; Practice="작은 기능 하나를 PRD.md 형식으로 작성한다."},
  @{N=37; Level="중급"; Part="Part 04. 프로젝트 메모리"; Title="progress.md로 장기 작업 관리"; Focus="긴 세션과 여러 날 작업에서 진행 상태를 파일로 유지한다."; Practice="완료, 진행 중, 다음 작업, 리스크를 기록하는 progress.md를 만든다."},
  @{N=38; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="기능 개발 프롬프트"; Focus="기능 구현을 요구사항, 영향 범위, 테스트, 문서까지 포함해 요청한다."; Practice="로그인 기능 추가 프롬프트를 작성한다."},
  @{N=39; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="버그 조사 프롬프트"; Focus="증상, 재현 절차, 기대 동작, 실제 동작, 로그를 제공해야 한다."; Practice="버그 리포트를 Claude Code용 조사 요청으로 바꾼다."},
  @{N=40; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="리팩터링 프롬프트"; Focus="리팩터링은 동작 유지와 검증 계획이 핵심임을 배운다."; Practice="동작 변경 금지 조건을 포함한 리팩터링 요청을 만든다."},
  @{N=41; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="테스트 생성 프롬프트"; Focus="핵심 경로, 경계 조건, 실패 조건을 테스트하게 한다."; Practice="테스트 없는 함수에 단위 테스트를 추가하는 요청을 작성한다."},
  @{N=42; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="문서 생성 프롬프트"; Focus="문서는 코드의 현재 동작과 동기화되어야 한다."; Practice="API 파일을 읽고 사용 예시가 포함된 문서를 생성하게 한다."},
  @{N=43; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="코드 리뷰 프롬프트"; Focus="리뷰는 심각도, 파일 위치, 재현 가능성, 수정 제안으로 구성한다."; Practice="diff를 기준으로 리뷰 코멘트 형식을 지정한다."},
  @{N=44; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="보안 리뷰 프롬프트"; Focus="입력 검증, 인증, 권한, 비밀정보, 의존성 위험을 점검한다."; Practice="API 엔드포인트 보안 체크리스트를 만든다."},
  @{N=45; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="성능 개선 프롬프트"; Focus="측정 없는 성능 개선은 추측이므로 병목 측정부터 요구한다."; Practice="느린 화면의 원인 조사와 측정 계획을 요청한다."},
  @{N=46; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="UI 개선 프롬프트"; Focus="UI 요청에는 대상 사용자, 정보 밀도, 반응형 조건, 접근성을 포함한다."; Practice="관리자 대시보드 개선 요청을 작성한다."},
  @{N=47; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="API 설계 요청법"; Focus="엔드포인트, 요청/응답, 오류, 인증, 테스트를 함께 설계한다."; Practice="게시글 댓글 API 설계를 요청한다."},
  @{N=48; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="데이터베이스 변경 요청법"; Focus="스키마 변경은 마이그레이션, 기존 데이터, 롤백을 함께 고려한다."; Practice="새 컬럼 추가 요청에 롤백 계획을 포함한다."},
  @{N=49; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="마이그레이션 작업 요청법"; Focus="데이터 변경 작업은 dry run, 백업, 검증 쿼리가 필요하다."; Practice="안전한 데이터 마이그레이션 체크리스트를 작성한다."},
  @{N=50; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="의존성 업데이트 요청법"; Focus="라이브러리 업데이트는 changelog, breaking changes, 테스트가 핵심이다."; Practice="한 패키지를 안전하게 업데이트하는 계획을 요청한다."},
  @{N=51; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="실패한 빌드 고치기"; Focus="빌드 로그를 읽고 최초 원인과 파생 오류를 구분한다."; Practice="빌드 실패 로그에서 가장 먼저 고칠 지점을 찾게 한다."},
  @{N=52; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="린트와 포맷 자동 수정"; Focus="스타일 문제와 의미 있는 코드 문제를 분리한다."; Practice="린트 오류를 자동 수정하고 남은 오류를 설명하게 한다."},
  @{N=53; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="PR 생성 워크플로"; Focus="브랜치, 커밋, 테스트, PR 설명, 리뷰 포인트를 연결한다."; Practice="현재 변경사항으로 PR 본문을 생성한다."},
  @{N=54; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="릴리스 노트 자동화"; Focus="커밋과 PR에서 사용자 관점 변경사항을 추출한다."; Practice="최근 커밋을 기능, 수정, 변경, 주의사항으로 분류한다."},
  @{N=55; Level="중급"; Part="Part 05. 실무 개발 워크플로"; Title="반복 작업 자동화"; Focus="반복적이고 기준이 명확한 작업은 자동화 후보가 된다."; Practice="매주 반복하는 개발 작업을 자동화 가능성으로 분류한다."},
  @{N=56; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="Claude Code와 VS Code"; Focus="IDE diff, 선택 영역, 파일 탐색과 Claude Code의 역할 분담을 이해한다."; Practice="VS Code에서 수정 검토 중심 workflow를 설계한다."},
  @{N=57; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="Claude Code와 JetBrains"; Focus="JetBrains 기반 프로젝트에서 Claude Code를 보조 개발자로 쓰는 방식을 익힌다."; Practice="선택한 파일/모듈 기준으로 질문하는 프롬프트를 만든다."},
  @{N=58; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="Claude Code Desktop 활용"; Focus="시각적 diff 검토, 멀티 세션, 예약 작업의 장점을 이해한다."; Practice="터미널 세션을 Desktop 검토 흐름으로 넘기는 시나리오를 만든다."},
  @{N=59; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="Claude Code Web 활용"; Focus="로컬 환경 없이 장기 작업과 병렬 작업을 시작하는 방식을 이해한다."; Practice="웹에서 맡길 만한 비차단 작업 목록을 만든다."},
  @{N=60; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="원격/모바일 작업 흐름"; Focus="세션이 하나의 표면에 묶이지 않고 이동할 수 있다는 점을 활용한다."; Practice="외부에서 버그 리포트를 보내고 로컬에서 검토하는 흐름을 설계한다."},
  @{N=61; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="세션 resume 전략"; Focus="긴 작업에서 맥락을 유지하되 오래된 잡음을 정리하는 법을 배운다."; Practice="resume 전 확인할 파일과 요약 요청을 만든다."},
  @{N=62; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="context window 관리"; Focus="컨텍스트는 무한하지 않으므로 요약, 제외, 파일화 전략이 필요하다."; Practice="큰 작업을 문서 기반 체크포인트로 나눈다."},
  @{N=63; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="70%, 85%, 90% 컨텍스트 압력 대응"; Focus="컨텍스트 압력이 높아질수록 정밀도가 낮아질 수 있음을 이해한다."; Practice="압력 구간별 /compact, 파일 요약, /clear 기준을 만든다."},
  @{N=64; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="비용과 모델 선택"; Focus="일상 작업과 복잡한 설계 작업에 다른 모델/노력을 배분한다."; Practice="업무 유형별 모델 선택 표를 만든다."},
  @{N=65; Level="중급"; Part="Part 06. 작업 환경 확장"; Title="중급자가 만드는 첫 자동화 시스템"; Focus="문서 요약, 이슈 정리, 테스트 실행 같은 작고 유용한 자동화를 설계한다."; Practice="매일 아침 실행할 개발 상태 요약 자동화를 설계한다."},
  @{N=66; Level="고급"; Part="Part 07. Skills"; Title="Skills 개념"; Focus="Skill은 반복 가능한 능력을 파일, 스크립트, 템플릿으로 패키징한 단위다."; Practice="자주 하는 작업 3개를 Skill 후보로 분류한다."},
  @{N=67; Level="고급"; Part="Part 07. Skills"; Title="SKILL.md 구조"; Focus="이름, 설명, 호출 조건, 절차, 참조 파일을 명확히 작성한다."; Practice="간단한 코드 리뷰 SKILL.md 골격을 작성한다."},
  @{N=68; Level="고급"; Part="Part 07. Skills"; Title="slash commands와 skills 차이"; Focus="legacy command와 현재 권장되는 skill 방식의 차이를 이해한다."; Practice="기존 명령을 Skill 구조로 마이그레이션하는 계획을 만든다."},
  @{N=69; Level="고급"; Part="Part 07. Skills"; Title="코드 리뷰 Skill 만들기"; Focus="리뷰 기준, 심각도, 출력 형식, 테스트 공백을 Skill에 담는다."; Practice="리뷰 결과 템플릿을 포함한 Skill을 설계한다."},
  @{N=70; Level="고급"; Part="Part 07. Skills"; Title="테스트 Skill 만들기"; Focus="테스트 전략, 실행 명령 탐색, 실패 해석 방식을 재사용 가능하게 만든다."; Practice="테스트 생성 및 실행 Skill 절차를 작성한다."},
  @{N=71; Level="고급"; Part="Part 07. Skills"; Title="문서화 Skill 만들기"; Focus="API 문서, 사용자 가이드, 변경 로그를 일관된 구조로 생성한다."; Practice="문서 스타일 가이드를 Skill 참조 파일로 분리한다."},
  @{N=72; Level="고급"; Part="Part 07. Skills"; Title="배포 체크리스트 Skill 만들기"; Focus="배포 전 확인 항목과 롤백 절차를 자동으로 점검한다."; Practice="staging 배포 전 점검 Skill을 설계한다."},
  @{N=73; Level="고급"; Part="Part 07. Skills"; Title="Skill의 progressive disclosure"; Focus="처음부터 모든 문서를 로드하지 않고 필요한 자료만 열게 한다."; Practice="참조 문서를 언제 읽을지 조건을 작성한다."},
  @{N=74; Level="고급"; Part="Part 07. Skills"; Title="쓸모없는 Skill 제거 기준"; Focus="모델 기본 능력을 방해하거나 컨텍스트만 낭비하는 Skill을 제거한다."; Practice="현재 Skill 목록을 유지, 수정, 삭제로 분류한다."},
  @{N=75; Level="고급"; Part="Part 08. Hooks"; Title="Hooks 개념"; Focus="Hooks는 Claude Code 이벤트에 반응해 자동으로 실행되는 검증/자동화 장치다."; Practice="파일 수정 전후에 필요한 자동 검사를 정리한다."},
  @{N=76; Level="고급"; Part="Part 08. Hooks"; Title="PreToolUse Hook"; Focus="도구 실행 전 차단, 확인, 로깅을 수행한다."; Practice="민감 파일 수정 차단 Hook 설계를 작성한다."},
  @{N=77; Level="고급"; Part="Part 08. Hooks"; Title="PostToolUse Hook"; Focus="도구 실행 후 포맷, 테스트, 스캔, 알림을 수행한다."; Practice="코드 파일 수정 후 포맷 명령을 실행하는 Hook을 설계한다."},
  @{N=78; Level="고급"; Part="Part 08. Hooks"; Title="파일 수정 전 보안 차단"; Focus=".env, secret, production config 같은 민감 파일 보호 전략을 세운다."; Practice="차단할 파일 패턴 목록을 만든다."},
  @{N=79; Level="고급"; Part="Part 08. Hooks"; Title="파일 수정 후 자동 포맷"; Focus="자동 포맷은 리뷰 비용을 줄이지만 실패 시 명확한 fallback이 필요하다."; Practice="언어별 포맷 명령 매핑표를 만든다."},
  @{N=80; Level="고급"; Part="Part 08. Hooks"; Title="커밋 전 테스트 Hook"; Focus="커밋 전 최소 테스트를 자동 실행해 회귀를 줄인다."; Practice="빠른 테스트와 전체 테스트를 구분한다."},
  @{N=81; Level="고급"; Part="Part 08. Hooks"; Title="명령어 로깅 Hook"; Focus="Claude가 실행한 명령을 기록하면 감사와 디버깅이 쉬워진다."; Practice="명령, 시간, 작업 폴더, 결과 코드를 남기는 로그 형식을 설계한다."},
  @{N=82; Level="고급"; Part="Part 08. Hooks"; Title="Hooks 보안 설계"; Focus="Hook 자체가 위험한 자동 실행 지점이 될 수 있으므로 최소 권한으로 설계한다."; Practice="Hook 보안 점검표를 작성한다."},
  @{N=83; Level="고급"; Part="Part 09. MCP"; Title="MCP 개념"; Focus="MCP는 Claude가 외부 데이터와 도구에 안전하게 접근하도록 하는 프로토콜이다."; Practice="내 프로젝트에서 필요한 외부 도구 후보를 정리한다."},
  @{N=84; Level="고급"; Part="Part 09. MCP"; Title="stdio MCP와 HTTP MCP"; Focus="로컬 실행 서버와 원격 HTTP 서버의 차이를 이해한다."; Practice="각 transport에 맞는 사용 사례를 3개씩 정리한다."},
  @{N=85; Level="고급"; Part="Part 09. MCP"; Title="GitHub MCP"; Focus="이슈, PR, 코드 리뷰, 릴리스 작업을 GitHub MCP로 연결한다."; Practice="PR 리뷰 자동화 시나리오를 설계한다."},
  @{N=86; Level="고급"; Part="Part 09. MCP"; Title="Database MCP"; Focus="데이터베이스 접근은 읽기 전용, 샌드박스, 승인 절차가 중요하다."; Practice="분석용 읽기 전용 DB MCP 정책을 작성한다."},
  @{N=87; Level="고급"; Part="Part 09. MCP"; Title="Filesystem MCP"; Focus="파일 접근 MCP는 강력하지만 범위 제한이 핵심이다."; Practice="허용 디렉터리와 금지 디렉터리를 분리한다."},
  @{N=88; Level="고급"; Part="Part 09. MCP"; Title="Browser/Chrome MCP"; Focus="브라우저 MCP는 웹 앱 검증, 스크린샷, DOM 조사에 유용하다."; Practice="프론트엔드 변경 후 브라우저 검증 플로우를 만든다."},
  @{N=89; Level="고급"; Part="Part 09. MCP"; Title="Notion, Jira, Slack 연결 전략"; Focus="업무 도구 연결은 편리하지만 권한과 데이터 노출을 설계해야 한다."; Practice="업무 도구별 읽기/쓰기 권한 정책을 만든다."},
  @{N=90; Level="고급"; Part="Part 09. MCP"; Title="OAuth와 인증 보안"; Focus="토큰 저장, 권한 범위, step-up auth, 철회 절차를 이해한다."; Practice="MCP 인증 운영 체크리스트를 만든다."},
  @{N=91; Level="고급"; Part="Part 09. MCP"; Title="MCP 서버 검증 체크리스트"; Focus="알 수 없는 MCP는 코드, 권한, 네트워크, 업데이트 정책을 검토한 뒤 사용한다."; Practice="5분 MCP 검증표를 작성한다."},
  @{N=92; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="Subagents 개념"; Focus="서브에이전트는 독립 컨텍스트와 역할 지침을 가진 전문 작업자다."; Practice="내 프로젝트에 필요한 에이전트 3개를 정의한다."},
  @{N=93; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="코드 리뷰어 에이전트"; Focus="코드 리뷰어는 버그, 보안, 회귀, 테스트 공백을 우선 찾는다."; Practice="코드 리뷰어 에이전트 설명문을 작성한다."},
  @{N=94; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="테스트 엔지니어 에이전트"; Focus="테스트 전략, 커버리지, 실패 재현을 전문화한다."; Practice="테스트 엔지니어에게 맡길 업무 범위를 정의한다."},
  @{N=95; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="문서 작성자 에이전트"; Focus="문서 작성자는 독자, 목적, 예제, 최신 코드 반영을 중시한다."; Practice="API 문서 작성 에이전트 지침을 만든다."},
  @{N=96; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="보안 리뷰어 에이전트"; Focus="보안 리뷰어는 읽기 전용 원칙과 명확한 심각도 분류가 필요하다."; Practice="보안 리뷰 결과 형식을 정의한다."},
  @{N=97; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="구현 에이전트"; Focus="구현 에이전트는 파일 소유권과 충돌 회피 규칙을 명확히 받아야 한다."; Practice="작업 범위와 금지 범위를 포함한 구현 지시문을 만든다."},
  @{N=98; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="Agent Teams와 병렬 작업"; Focus="큰 작업은 독립된 하위 문제로 나눌 때 병렬화 효과가 난다."; Practice="기능 하나를 병렬 가능한 3개 작업으로 분해한다."},
  @{N=99; Level="고급"; Part="Part 10. Subagents와 Agent Teams"; Title="Worktree 기반 멀티 에이전트 개발"; Focus="Git worktree를 활용하면 병렬 작업 충돌을 줄일 수 있다."; Practice="프론트엔드, 백엔드, 테스트 worktree 전략을 설계한다."},
  @{N=100; Level="고급"; Part="Part 11. 프로덕션 운영"; Title="Claude Code 프로덕션 운영 전략"; Focus="AI 개발 결과물을 운영하려면 테스트, 보안, 배포, 모니터링, 피드백 루프가 필요하다."; Practice="프로덕션 출시 전 최종 점검표를 작성한다."}
)

$appendices = @(
  @{N=101; Title="명령어 치트시트"; Focus="Claude Code에서 자주 쓰는 명령과 slash command를 빠르게 찾는다."},
  @{N=102; Title="Claude Code 설치 문제 해결"; Focus="Windows, macOS, Linux 설치 오류를 진단한다."},
  @{N=103; Title="Windows PowerShell 주의사항"; Focus="PowerShell, CMD, Git Bash, WSL의 명령 차이를 정리한다."},
  @{N=104; Title="WikiDocs GitHub 출판 가이드"; Focus="README.md, TOC.md, pages, assets 구조로 WikiDocs 책을 출판한다."},
  @{N=105; Title="추천 .claude 폴더 구조"; Focus="commands, skills, agents, hooks, settings 파일 배치를 설계한다."},
  @{N=106; Title="추천 CLAUDE.md 템플릿"; Focus="프로젝트 규칙과 실행 명령을 담는 템플릿을 제공한다."},
  @{N=107; Title="추천 PRD.md 템플릿"; Focus="제품 요구사항을 명확히 쓰는 템플릿을 제공한다."},
  @{N=108; Title="추천 Skill 템플릿"; Focus="SKILL.md 기본 구조를 제공한다."},
  @{N=109; Title="추천 Hook 템플릿"; Focus="안전한 Hook 설계 예시를 제공한다."},
  @{N=110; Title="MCP 보안 감사표"; Focus="MCP 서버 도입 전 권한과 위험을 점검한다."},
  @{N=111; Title="AI 앱 평가 체크리스트"; Focus="정확성, 안정성, 비용, 지연, 사용자 만족도를 평가한다."},
  @{N=112; Title="RAG 설계 체크리스트"; Focus="문서 수집, 청킹, 임베딩, 검색, 재랭킹, 평가를 점검한다."},
  @{N=113; Title="JSON 출력 검증 패턴"; Focus="스키마 기반 구조화 출력과 실패 대응을 설계한다."},
  @{N=114; Title="Docker 배포 예시"; Focus="AI 애플리케이션을 컨테이너화하는 기본 흐름을 정리한다."},
  @{N=115; Title="CI/CD 자동화 예시"; Focus="테스트, 빌드, 배포, 리뷰 자동화를 연결한다."},
  @{N=116; Title="모니터링과 로깅 설계"; Focus="AI 시스템의 입력, 출력, 오류, 비용, 지연을 관찰한다."},
  @{N=117; Title="비용 최적화 전략"; Focus="모델 선택, 캐싱, 컨텍스트 축소, 배치 처리로 비용을 낮춘다."},
  @{N=118; Title="팀 도입 가이드"; Focus="개인 실험에서 팀 표준으로 확장하는 절차를 정리한다."},
  @{N=119; Title="비개발자 업무 자동화 예시"; Focus="문서, 스프레드시트, 이메일, 리서치 자동화 사례를 정리한다."},
  @{N=120; Title="최종 프로젝트 10개"; Focus="책 전체 내용을 종합하는 실전 프로젝트 목록을 제공한다."}
)

$imagePrompts = @(
  @{File="00-cover.png"; Title="표지"; Prompt="A polished Korean technical book cover about Claude AI and Claude Code, showing a terminal, code editor, AI agent network, MCP connectors, and production deployment pipeline, modern professional style, clean typography space, blue white black accent, no logos, no text"},
  @{File="01-agent-loop.png"; Title="에이전트 루프"; Prompt="Educational diagram style illustration of an AI coding agent loop: read files, plan, edit, run commands, test, review, iterate. Minimal modern vector-like raster image, Korean textbook friendly, no text"},
  @{File="02-claude-ecosystem.png"; Title="Claude 생태계"; Prompt="Modern clean infographic without text showing Claude Web, Desktop, CLI terminal, IDE, API, MCP, skills, hooks, and agents as connected modules around a central AI core"},
  @{File="03-chatbot-vs-agent.png"; Title="챗봇 vs 에이전트"; Prompt="Side by side educational visual: left simple chat bubble answer, right autonomous agent reading files, editing code, running tests, checking results. No text, clean high contrast"},
  @{File="04-memory-structure.png"; Title="CLAUDE.md 메모리"; Prompt="Clean technical illustration of project memory: root instructions, directory instructions, personal memory, auto memory, docs references, shown as layered folders and notes, no text"},
  @{File="05-skills-hooks-mcp-agents.png"; Title="확장 구조"; Prompt="Professional architecture illustration showing skills, hooks, MCP servers, and subagents connected to Claude Code terminal in a software project workspace, no text"},
  @{File="06-mcp-architecture.png"; Title="MCP 아키텍처"; Prompt="Architecture diagram style image of an AI agent connecting through MCP servers to GitHub, database, browser, Slack, Notion, and filesystem, secure connectors, no text"},
  @{File="07-agent-teams.png"; Title="Agent Teams"; Prompt="Clean illustration of a lead AI coding agent coordinating multiple specialist agents for frontend, backend, tests, security, docs, with git branches/worktrees, no text"},
  @{File="08-rag-pipeline.png"; Title="RAG 파이프라인"; Prompt="Technical education diagram showing document ingestion, chunking, embeddings, vector database, retrieval, generation, evaluation, monitoring, no text"},
  @{File="09-production-pipeline.png"; Title="프로덕션 파이프라인"; Prompt="Modern DevOps pipeline illustration for AI application: prompt templates, tests, schema validation, Docker, CI/CD, cloud deployment, monitoring dashboard, no text"}
)

function New-Slug([string]$title) {
  $slug = $title.ToLowerInvariant()
  $slug = $slug -replace "[^a-z0-9가-힣]+", "-"
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) { return "page" }
  return $slug
}

function Write-Utf8NoBom($Path, $Content) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  $fullPath = if ($dir) {
    Join-Path (Resolve-Path -LiteralPath $dir).Path (Split-Path -Leaf $Path)
  } else {
    Join-Path (Get-Location).Path $Path
  }
  [System.IO.File]::WriteAllText($fullPath, $Content, [System.Text.UTF8Encoding]::new($false))
}

New-Item -ItemType Directory -Force -Path "pages", "assets", "tools" | Out-Null

$readme = @"
# $bookTitle

Claude, Claude Code, MCP, Skills, Hooks, Subagents, Agent Teams, RAG, 평가, 배포, 운영까지 한 권으로 연결하는 100선 실전서입니다.

- 기준일: $date
- 저자: $author
- 대상 독자: 초급자, 실무 개발자, 자동화 담당자, AI 제품 기획자, 팀 리더
- 핵심 주제: AI 에이전트로 혼자서 앱, 자동화, 업무 시스템을 만드는 법

이 책은 단순한 기능 소개가 아니라 실제 프로젝트에서 Claude와 Claude Code를 어떻게 도입하고, 어떻게 안전하게 확장하며, 어떻게 운영 가능한 결과물로 만드는지를 단계별로 다룹니다.
"@
Write-Utf8NoBom "README.md" $readme

$tocLines = New-Object System.Collections.Generic.List[string]
$tocLines.Add("# 목차")
$tocLines.Add("")
$tocLines.Add("저자: $author")
$tocLines.Add("")
$tocLines.Add("- [000. 들어가며](pages/000-preface.md)")

$currentPart = ""
foreach ($t in $topics) {
  if ($t.Part -ne $currentPart) {
    $currentPart = $t.Part
    $partNo = "{0:000}" -f $t.N
    $partFile = "pages/$partNo-part.md"
    $tocLines.Add("- [$currentPart]($partFile)")
  }
  $file = "pages/{0:000}-{1}.md" -f $t.N, (New-Slug $t.Title)
  $num = "{0:000}" -f $t.N
  $tocLines.Add("  - [$num. $($t.Title)]($file)")
}
$tocLines.Add("- [부록](pages/101-appendix.md)")
foreach ($a in $appendices) {
  $file = "pages/{0:000}-{1}.md" -f $a.N, (New-Slug $a.Title)
  $num = "{0:000}" -f $a.N
  $tocLines.Add("  - [$num. $($a.Title)]($file)")
}
$tocLines.Add("  - [900. 이미지 생성 계획](pages/900-image-generation-plan.md)")
$tocLines.Add("  - [999. 마무리](pages/999-closing.md)")
Write-Utf8NoBom "TOC.md" ($tocLines -join "`r`n")

$preface = @"
## 000. 들어가며

저자: $author

이 책의 목표는 Claude를 잘 묻는 도구로만 사용하는 수준을 넘어, Claude Code와 함께 실제 프로젝트를 읽고, 수정하고, 테스트하고, 배포하고, 운영하는 능력을 갖추는 것입니다.

2026년 05월 03일 기준으로 Claude 생태계는 웹 대화, 데스크톱 앱, 터미널 기반 Claude Code, IDE 통합, MCP, Skills, Hooks, Subagents, Agent Teams, Agent SDK까지 확장되어 있습니다. 이 책은 그 요소들을 흩어진 기능으로 설명하지 않고 하나의 실전 흐름으로 묶습니다.

### 이 책의 독자

- Claude를 처음 쓰는 사람
- Claude Code로 개발 생산성을 높이고 싶은 사람
- 업무 자동화와 AI 에이전트 시스템을 만들고 싶은 사람
- 팀에 AI 개발 워크플로를 도입하려는 사람
- 프로덕션 AI 애플리케이션의 평가, 보안, 배포, 운영을 고민하는 사람

### 읽는 방법

초급자는 001번부터 순서대로 읽으세요. 개발 경험이 있다면 031번부터 시작해도 됩니다. Claude Code를 이미 사용 중이라면 066번 Skills, 075번 Hooks, 083번 MCP, 092번 Subagents부터 읽고 필요한 부분으로 돌아오면 됩니다.

### 중요한 원칙

Claude와 Claude Code는 강력하지만 검증을 대체하지 않습니다. 이 책은 빠른 자동화보다 재현 가능한 결과, 작은 범위의 안전한 변경, 테스트 가능한 구현, 보안 검토, 운영 가능한 구조를 우선합니다.
"@
Write-Utf8NoBom "pages/000-preface.md" $preface

$partNames = $topics | ForEach-Object { $_.Part } | Select-Object -Unique
foreach ($partName in $partNames) {
  $partGroup = @($topics | Where-Object { $_.Part -eq $partName })
  $first = $partGroup[0]
  $partFile = "pages/{0:000}-part.md" -f $first.N
  $items = ($partGroup | ForEach-Object { "- {0:000}. {1}: {2}" -f $_.N, $_.Title, $_.Focus }) -join "`r`n"
$content = @"
## $partName

저자: $author

이 장은 $($first.Level) 단계 독자를 위한 흐름입니다. 각 페이지는 하나의 주제를 다루며, 개념 설명과 실습 프롬프트를 함께 제공합니다.

### 이 장에서 다루는 100선 항목

$items

### 학습 방식

각 항목을 읽은 뒤 바로 Claude 또는 Claude Code에 실습 프롬프트를 입력해 보세요. 읽기만 하면 기능 목록으로 남고, 직접 실행하면 작업 습관으로 바뀝니다.
"@
  Write-Utf8NoBom $partFile $content
}

foreach ($t in $topics) {
  $file = "pages/{0:000}-{1}.md" -f $t.N, (New-Slug $t.Title)
  $next = if ($t.N -lt 100) { "{0:000}" -f ($t.N + 1) } else { "101" }
  $content = @"
## $("{0:000}" -f $t.N). $($t.Title)

난이도: $($t.Level)  
기준일: $date
저자: $author

### 핵심 개념

$($t.Focus)

Claude를 잘 쓰는 사람은 도구 이름을 많이 아는 사람이 아니라, 현재 작업에 필요한 맥락과 검증 기준을 정확히 주는 사람입니다. 이 주제에서는 기능의 표면적 사용법보다 실제 작업에서 실패를 줄이는 기준을 먼저 잡습니다.

### 왜 중요한가

AI 도구는 애매한 요청에도 자신감 있게 답합니다. 따라서 사용자는 목표, 범위, 제약, 완료 기준을 명확히 해야 합니다. Claude Code를 사용할 때는 특히 파일 수정, 명령 실행, 외부 도구 연결이 실제 환경에 영향을 줄 수 있으므로 작은 범위에서 계획하고 검증하는 습관이 중요합니다.

### 실습

$($t.Practice)

### Claude 또는 Claude Code에 입력할 프롬프트

``````text
나는 "$($t.Title)" 주제를 배우고 있다.
현재 내 목표는 다음과 같다.

목표:
- $($t.Focus)

요청:
1. 이 개념을 초급자도 이해할 수 있게 설명해줘.
2. 실무에서 언제 쓰는지 예시를 3개 들어줘.
3. 내가 바로 따라 할 수 있는 작은 실습을 제안해줘.
4. 흔한 실수와 검증 방법을 체크리스트로 정리해줘.
``````

### 체크리스트

- [ ] 이 주제를 한 문장으로 설명할 수 있다.
- [ ] 이 주제가 필요한 상황과 필요하지 않은 상황을 구분할 수 있다.
- [ ] Claude에게 줄 요청에 목표, 범위, 제약을 포함할 수 있다.
- [ ] 결과물을 테스트하거나 검토하는 기준을 정할 수 있다.

### 흔한 실수

- 결과가 그럴듯하다는 이유로 검증을 생략한다.
- 전체 프로젝트를 한 번에 바꾸라고 요청한다.
- 비밀정보, 운영 설정, 민감 파일을 무심코 포함한다.
- 실패했을 때 원인 분석 없이 같은 요청을 반복한다.

### 다음 단계

다음 항목으로 넘어가기 전에 이 페이지의 프롬프트를 실제 프로젝트나 샘플 폴더에서 한 번 실행해 보세요. 다음 페이지 번호: $next
"@
  Write-Utf8NoBom $file $content
}

$appendixIntro = @"
## 부록

저자: $author

부록은 본문 100선을 실제 프로젝트와 팀 운영에 적용할 때 필요한 템플릿, 체크리스트, 출판 가이드를 모았습니다.
"@
Write-Utf8NoBom "pages/101-appendix.md" $appendixIntro

foreach ($a in $appendices) {
  $file = "pages/{0:000}-{1}.md" -f $a.N, (New-Slug $a.Title)
$content = @"
## $("{0:000}" -f $a.N). $($a.Title)

저자: $author

### 목적

$($a.Focus)

### 바로 쓰는 템플릿

``````text
상황:

목표:

입력 자료:

제약 조건:

완료 기준:

검증 방법:
``````

### 적용 체크리스트

- [ ] 이 항목을 현재 프로젝트에 적용할 이유가 명확하다.
- [ ] 보안 또는 권한 문제가 있는지 확인했다.
- [ ] 팀원이 읽어도 이해할 수 있게 문서화했다.
- [ ] 실패했을 때 되돌릴 방법을 준비했다.

### 메모

이 부록은 책의 본문을 실제 환경에 옮기는 데 쓰는 실무 도구입니다. 프로젝트마다 명령어와 정책이 다르므로 그대로 복사하기보다 현재 저장소의 구조에 맞게 조정하세요.
"@
  Write-Utf8NoBom $file $content
}

$imgLines = New-Object System.Collections.Generic.List[string]
$imgLines.Add("## 900. 이미지 생성 계획")
$imgLines.Add("")
$imgLines.Add("저자: $author")
$imgLines.Add("")
$imgLines.Add('이 페이지는 GPT image 2.0으로 생성할 학습용 이미지 목록입니다. 생성된 이미지는 `assets/` 폴더에 저장하고 각 장의 본문에서 상대 경로로 참조합니다.')
$imgLines.Add("")
foreach ($img in $imagePrompts) {
  $imgLines.Add("### $($img.Title)")
  $imgLines.Add("")
  $imgLines.Add(('- 파일명: `assets/{0}`' -f $img.File))
  $imgLines.Add(('- 삽입 예시: `![{0}](../assets/{1})`' -f $img.Title, $img.File))
  $imgLines.Add("")
  $imgLines.Add('```text')
  $imgLines.Add($img.Prompt)
  $imgLines.Add('```')
  $imgLines.Add("")
}
Write-Utf8NoBom "pages/900-image-generation-plan.md" ($imgLines -join "`r`n")

$closing = @"
## 999. 마무리

저자: $author

Claude와 Claude Code를 배우는 목적은 더 많은 명령어를 외우는 것이 아닙니다. 목적은 더 명확하게 생각하고, 더 작은 단위로 실행하고, 더 엄격하게 검증하며, 반복 가능한 업무 시스템을 만드는 것입니다.

이 책의 100선을 끝까지 따라왔다면 다음 네 가지를 할 수 있어야 합니다.

1. Claude에게 애매하지 않은 요청을 줄 수 있다.
2. Claude Code로 실제 코드베이스를 읽고 수정하고 테스트할 수 있다.
3. Skills, Hooks, MCP, Subagents를 필요한 만큼만 선별해 확장할 수 있다.
4. AI 애플리케이션을 평가, 배포, 모니터링, 개선하는 관점으로 설계할 수 있다.

마지막 과제는 간단합니다. 지금 반복해서 하고 있는 업무 하나를 고르세요. 그리고 그 업무를 Claude Code가 읽고, 계획하고, 실행하고, 검증할 수 있는 작은 자동화 시스템으로 바꾸세요. 그것이 이 책의 출발점이자 도착점입니다.
"@
Write-Utf8NoBom "pages/999-closing.md" $closing

Write-Host "Generated WikiDocs book scaffold: README.md, TOC.md, pages/, assets/"
