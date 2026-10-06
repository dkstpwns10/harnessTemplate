#!/bin/sh
# SessionStart hook: 진행 중 작업과 기억 경고를 새 세션의 context에 넣는다 (stdout).
# 내용을 통째로 넣지 않는다 — 요약 머리말만 넣고 나머지는 필요할 때 읽게 한다.

ROOT=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
cd "$ROOT" || exit 0
CUR=.harness/state/current.md
if [ -f "$CUR" ]; then
  echo "HARNESS: 진행 중인 작업이 있다 ($CUR). 이어서 하려면 task-resume skill을 쓴다. 새 작업이면 사용자에게 기존 작업을 어떻게 할지 먼저 묻는다."
  grep -E '^- (Task|Triage|PRD|Stage|Updated)' "$CUR" | head -n 6
  NEXT=$(awk '/^## Next/{f=1;next} /^## /{f=0} f&&NF{print;exit}' "$CUR")
  [ -n "$NEXT" ] && echo "- Next: $NEXT"
fi
CM=.harness/project/codemap.md
if [ -f "$CM" ] && grep -q '^Last verified: [0-9]' "$CM"; then
  echo "HARNESS: 코드 구조 기억이 있다 ($CM, $(grep -m1 '^Last verified:' "$CM")). 코드를 탐색·수정하기 전에 먼저 읽는다. 기록은 힌트이므로 해당 파일을 실제로 확인한다."
fi
[ -x .harness/memory-check ] && .harness/memory-check -q
exit 0
