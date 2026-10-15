# Orchestration runtime, swarm, 에이전트 팀

**왜 넣지 않는가**: 별도 런타임(MCP 서버, 데몬, swarm topology, consensus)은 설치·업데이트·장애 대응 비용이 크고, 실패했을 때 원인을 찾기 어렵다. 이 하네스의 병목은 코드 생산이 아니라 요구사항 누락과 검증이며, 에이전트 수를 늘린다고 그것이 줄지 않는다. 비용도 에이전트 수에 비례해 는다.

**대신**: CLI 기본 기능만 쓴다 — subagent는 독립 관점이 필요한 읽기 전용 Role(researcher, architect, reviewer, debugger, prd-reviewer)에만. 큰 작업은 티켓으로 나눠 세션을 이어 간다.

**다시 검토할 조건**: 같은 저장소에서 서로 의존하지 않는 작업을 동시에 돌려야 하는 일이 반복해서 관찰될 때. 그때도 먼저 CLI 기본 기능(백그라운드 세션, worktree)으로 해결되는지 본다.

**이전 제안**: 2026-10-16, ruvnet/ruflo 비교 (100+ 에이전트, hierarchical swarm, Claude+Codex 이중 실행).
