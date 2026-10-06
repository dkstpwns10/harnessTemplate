#!/bin/sh
# PreToolUse 가드 (파일 수정). exit 2 = 차단, stderr가 모델에게 전달된다.
#   Claude Code: Edit|Write|MultiEdit|NotebookEdit → tool_input.file_path / notebook_path
#   Codex CLI:   apply_patch → tool_input.command 안의 "*** Add|Update|Delete File: <path>" 줄
# 1) 비밀 파일 수정 금지  2) 하네스 파일은 사용자 승인 없이 수정 금지
# 승인 방법: 사용자가 HARNESS_UNLOCK=1 로 CLI를 실행하거나 직접 편집.

INPUT=$(cat)
FILES=$(printf '%s' "$INPUT" | grep -o '"\(file_path\|notebook_path\)"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:[[:space:]]*"\(.*\)"/\1/')
PATCH=$(printf '%s' "$INPUT" | grep -o '\*\*\* \(Add\|Update\|Delete\) File: [^\\"]*' | sed 's/^\*\*\* [A-Za-z]* File: //')
[ -z "$FILES$PATCH" ] && exit 0

ROOT=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}

check() {
  REL=${1#"$ROOT"/}; REL=${REL#./}
  block() { echo "BLOCKED by harness guard: $1 ($REL)" >&2; exit 2; }

  case "$REL" in
    .env|.env.*|*/.env|*/.env.*)
      case "$REL" in *.example|*.sample) ;; *) block "비밀 파일은 수정하지 않습니다. 필요한 변수 이름만 사용자에게 안내하세요" ;; esac ;;
    *.pem|*.key|*id_rsa*|*id_ed25519*|*.p12|*.jks) block "키 파일은 수정하지 않습니다" ;;
    .git/*|*/.git/*) block ".git 내부는 수정하지 않습니다" ;;
  esac

  [ -n "$HARNESS_UNLOCK" ] && return 0

  case "$REL" in
    .harness/state/*|.harness/project/*) return 0 ;;   # 작업 상태 / 프로젝트 소유 설정은 허용
    .harness/*|AGENTS.md|CLAUDE.md|.claude/*|.codex/*|.agents/*)
      block "하네스 파일은 사용자 승인 후에만 수정합니다. docs/improvements.md에 제안을 기록하고 사용자에게 확인하세요 (승인 시 HARNESS_UNLOCK=1)" ;;
  esac
  return 0
}

printf '%s\n%s\n' "$FILES" "$PATCH" | while IFS= read -r f; do
  [ -n "$f" ] && check "$f"
done
# 파이프 서브셸의 exit 2를 전달
[ $? -eq 2 ] && exit 2
exit 0
