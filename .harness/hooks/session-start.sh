#!/bin/sh
# SessionStart hook: 진행 중 작업과 기억 경고를 새 세션의 context에 넣는다 (stdout).
# 내용을 통째로 넣지 않는다 — 요약 머리말만 넣고 나머지는 필요할 때 읽게 한다.
# 예외: context 압축(compact) 직후에는 같은 작업이 이어지므로 current.md 전체와 현재 변경·검증 상태를 넣는다.

INPUT=""
[ -t 0 ] || INPUT=$(cat 2>/dev/null)
SOURCE=$(printf '%s' "$INPUT" | grep -o '"source"[[:space:]]*:[[:space:]]*"[a-z]*"' | sed 's/.*"\([a-z]*\)"$/\1/')

ROOT=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
cd "$ROOT" || exit 0
CUR=.harness/state/current.md

if [ "$SOURCE" = compact ] && [ -f "$CUR" ]; then
  echo "HARNESS: context가 압축됐다. 압축 전 대화의 세부는 믿지 말고 아래 기록과 실제 상태를 기준으로 이어 간다."
  echo "---- $CUR ----"
  head -n 60 "$CUR"
  if git rev-parse --git-dir >/dev/null 2>&1; then
    # 바뀐 파일 중 current.md에 backtick 경로로 적히지 않은 것 (디렉터리 항목은 그 아래 전체를 덮는다)
    set -f
    KNOWN=$(grep -o '`[^` ]*`' "$CUR" | tr -d '`' | sed -e 's/:[0-9][0-9,:-]*$//' -e 's#^\./##' -e 's#/$##' | sort -u)
    CHANGED=$( { git -c core.quotePath=false diff HEAD --name-only 2>/dev/null || git -c core.quotePath=false diff --cached --name-only 2>/dev/null
                 git -c core.quotePath=false ls-files -o --exclude-standard 2>/dev/null; } | grep -v '^\.harness/state/' | sort -u)
    MISSING=""
    while IFS= read -r f; do               # 줄 단위로 읽는다 (공백이 든 경로)
      [ -n "$f" ] || continue
      hit=0
      for k in $KNOWN; do case "$f" in "$k"|"$k"/*) hit=1; break ;; esac; done
      [ "$hit" -eq 0 ] && MISSING="$MISSING- \`$f\`
"
    done <<LIST
$CHANGED
LIST
    set +f
    if [ -n "$MISSING" ]; then
      echo "---- 바뀌었지만 current.md에 없는 파일 — 아래 줄을 backtick 그대로 'Changed so far'에 추가하고(계획 밖이면 이유도), 그다음 Next를 진행한다 (backtick이 없으면 경로로 인식되지 않아 범위 경고가 남는다) ----"
      printf '%s' "$MISSING"
    else
      echo "---- 바뀐 파일은 모두 current.md에 기록돼 있다. Next부터 진행한다 ----"
    fi
  fi
  [ -f .harness/verify ] && sh .harness/verify status 2>/dev/null
  [ -x .harness/memory-check ] && .harness/memory-check -q
  [ -f .harness/manifest ] && sh .harness/manifest -q
  exit 0
fi

if [ -f "$CUR" ]; then
  echo "HARNESS: 진행 중인 작업이 있다 ($CUR). 이어서 하려면 task-resume skill을 쓴다. 새 작업이면 사용자에게 기존 작업을 어떻게 할지 먼저 묻는다."
  grep -E '^- (Task|Triage|PRD|Stage|Updated)' "$CUR" | head -n 6
  NEXT=$(awk '/^## Next/{f=1;next} /^## /{f=0} f&&NF{print;exit}' "$CUR")
  [ -n "$NEXT" ] && echo "- Next: ${NEXT#- }"
fi
CM=.harness/project/codemap.md
if [ -f "$CM" ] && grep -q '^Last verified: [0-9]' "$CM"; then
  echo "HARNESS: 코드 구조 기억이 있다 ($CM, $(grep -m1 '^Last verified:' "$CM")). 코드를 탐색·수정하기 전에 먼저 읽는다. 기록은 힌트이므로 해당 파일을 실제로 확인한다."
fi
[ -x .harness/memory-check ] && .harness/memory-check -q
[ -f .harness/manifest ] && sh .harness/manifest -q
exit 0
