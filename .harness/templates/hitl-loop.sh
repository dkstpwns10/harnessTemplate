#!/bin/sh
# 사람이 개입해야 하는 재현 절차를 스크립트로 고정한다 (bugfix 1단계의 최후 수단).
# 사용: 이 파일을 .harness/state/ 등으로 복사해 아래 단계를 고친 뒤, 사용자가 자기 터미널에서 실행한다.
#   sh .harness/state/repro.sh
# 끝에 KEY=VALUE 줄을 출력한다. 사용자가 그 부분을 붙여 주면 AI가 판정에 쓴다.
# 비밀번호·토큰은 capture로 받지 않는다 (출력에 남는다). 로그인 같은 일은 step으로 사용자에게 맡긴다.

step() {      # step "<지시>"  — 지시를 보여 주고 Enter를 기다린다
  printf '\n>>> %s\n    [끝나면 Enter] ' "$1"
  read -r _
}
capture() {   # capture VAR "<질문>" — 답을 VAR에 담는다
  printf '\n>>> %s\n    > ' "$2"
  read -r _ans
  eval "$1=\$_ans"
  CAPTURED="$CAPTURED $1"
}
CAPTURED=""

# ---- 여기부터 고친다 ----
step "앱을 띄우고 로그인한다 (http://localhost:8080)."
capture ERRORED "'내보내기' 버튼을 누른다. 에러가 났나? (y/n)"
capture ERROR_MSG "에러 메시지를 붙여 넣는다 (없으면 none):"
# ---- 여기까지 ----

printf '\n--- captured ---\n'
for v in $CAPTURED; do eval "printf '%s=%s\n' \"\$v\" \"\${$v}\""; done
