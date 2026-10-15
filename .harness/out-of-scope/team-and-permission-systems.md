# 다인 협업 기능, 독립 Permission/Git 시스템

**왜 넣지 않는가**: 대상은 1인 개발자다. 권한·git 보호는 CLI의 permission(allow/ask/deny)과 hook으로 충분하고, 별도 시스템은 두 CLI와 따로 놀며 유지 비용이 든다.

**대신**: `.claude/settings.json`, `.codex/rules`, `guard-bash.sh`, `guard-paths.sh`, `manifest`(하네스 파일 변경 감지).

**다시 검토할 조건**: 여러 사람이 같은 하네스로 한 저장소를 다룰 때.

**이전 제안**: 2026-10-03 설계 단계.
