#!/bin/sh
# PreToolUse(Bash) 가드. stdin: Claude Code hook JSON. exit 2 = 차단(stderr가 Claude에게 전달됨).
# 목적: 되돌릴 수 없는 행동과 비밀 노출만 차단한다. 나머지는 permission(ask)과 사용자 판단에 맡긴다.
# 한계: 정규식 기반이라 우회 가능하다 (감지/방어선 중 하나일 뿐, 보안 경계가 아니다).

INPUT=$(cat)
block() { echo "BLOCKED by harness guard: $1 — 사용자에게 설명하고 직접 실행을 요청하세요. 우회하지 마세요." >&2; exit 2; }
has() { printf '%s' "$INPUT" | grep -Eq "$1"; }

# 명령 위치 앵커: 명령의 시작, 구분자(; & | ( ` {) 뒤, 줄바꿈(\n) 뒤, $( 뒤. sudo/env 같은 래퍼와 if/do 같은 셸 키워드는 건너뛴다.
# 이렇게 해야 커밋 메시지나 grep 검색어 안에 들어 있는 같은 문자열을 오탐하지 않는다.
C='(^|[;&|(`{]|"command"[[:space:]]*:[[:space:]]*"|\\n|\$\()[[:space:]]*((sudo|command|time|nohup|env|if|then|else|elif|do|while|until|!)[[:space:]]+)*'

# 1) git: 이력 파괴 / 미커밋 변경 손실
has "${C}git[[:space:]]+push[^\";&|]*(--force|--force-with-lease|[[:space:]]-f([[:space:]\"]|\$))" && block "force push"
has "${C}git[[:space:]]+reset[[:space:]]+[^\";&|]*--hard"   && block "git reset --hard (미커밋 변경 손실)"
has "${C}git[[:space:]]+clean[[:space:]]+[^\";&|]*-[a-z]*f"  && block "git clean -f (추적되지 않은 파일 삭제)"
has "${C}git[[:space:]]+(checkout|restore)[[:space:]]+(--[[:space:]]+)?\.([[:space:]\"]|\$)" && block "전체 변경 되돌리기"
has "${C}git[[:space:]]+(rebase|filter-branch|filter-repo)" && block "history 재작성"
has "${C}git[[:space:]]+branch[[:space:]]+-D"            && block "branch 강제 삭제"

# 2) 파괴적 파일 명령
has "${C}rm[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-[a-zA-Z]*[rR][a-zA-Z]*[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*(/|~|~/|\\\$HOME|\*|\.|\./)([[:space:]\"]|\$)" && block "rm -r 대상이 위험함"

# 3) 비밀 정보: 읽기+출력, 커밋
SECRET_FILE='(\.env([^.a-zA-Z_-]|$|\.local|\.prod|\.dev|\.staging)|\.pem|id_rsa|id_ed25519|\.p12|\.jks|credentials(\.json)?([[:space:]"]|$))'
has "${C}(cat|less|more|head|tail|bat|grep|rg|sed|awk|strings|xxd|od|base64|cp|scp|source|\.)[[:space:]][^|;&]*${SECRET_FILE}" && block "비밀 파일 내용 노출"
has "${C}(printenv|export[[:space:]]+-p|env)[[:space:]]*([\"|;&>]|\$)" && block "환경변수 전체 출력"
has "${C}(echo|printf)[^|;&]*\\\$\{?[A-Za-z_]*(SECRET|TOKEN|PASSWORD|PASSWD|API_?KEY|PRIVATE)" && block "비밀 환경변수 출력"
has "${C}git[[:space:]]+add[[:space:]]+(-A|--all|\.)([[:space:]\"]|\$)" && block "git add -A/. (비밀/무관 파일 포함 위험) — 파일을 지정해서 add"
has "${C}git[[:space:]]+add[^\";&|]*${SECRET_FILE}" && block "비밀 파일 git add"

# 4) 운영 환경: 호스트·프로필·컨텍스트 이름에 prod가 들어간 대상 (프로젝트에 맞게 PROD_PATTERN 수정)
PROD_PATTERN='(-h[[:space:]]*|--host[= ]|@|://)[a-zA-Z0-9._-]*(prod|production)|--profile[= ]prod|-Dspring\.profiles\.active=prod|--context[= ][a-zA-Z0-9._-]*prod'
has "$PROD_PATTERN" && block "운영 환경 대상 명령"

exit 0
