# 파일 경계별 구현 subagent

**왜 넣지 않는가**: 구조·API·테스트·인프라 등 파일 경계마다 구현 에이전트를 두면, 하나의 동작을 만드는 변경이 여러 에이전트에 쪼개져 수직 슬라이스가 깨지고 조율 비용이 생긴다. 기술별 Agent도 같은 이유로 만들지 않는다 (Role + Skill 조합).

**대신**: Implementer는 메인 세션 하나. 큰 일은 수직 슬라이스 티켓으로 나눈다.

**다시 검토할 조건**: 없음 (병렬 작성 자체를 넣을 때 함께 검토).

**이전 제안**: 2026-10-16, JieDannaChen/agent-harness 비교 (structure/api/test/telemetry/upgrade/infra-agent).
