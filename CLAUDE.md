@AGENTS.md

## Claude Code 전용

- Subagent는 `.claude/agents/`에 있다. Reviewer에게는 요구사항 경로, 변경 파일, verify 결과만 넘긴다. FULL 등급에서는 reviewer를 호출할 때 `model: opus`를 지정한다.
- Workflow skill은 `/feature`, `/bugfix`, `/refactor`, `/investigate`, `/requirements`, `/task-resume`, `/task-done`으로 직접 호출할 수 있다.
- 권한 규칙과 Hook은 `.claude/settings.json`에 있다. 개인 설정은 `.claude/settings.local.json`, 개인 지침은 `CLAUDE.local.md`에 둔다 (둘 다 git 제외).
