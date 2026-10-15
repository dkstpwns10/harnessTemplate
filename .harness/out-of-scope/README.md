# 넣지 않기로 한 것

하네스에 넣자는 제안을 검토해 **넣지 않기로 한 개념**을 파일 하나에 하나씩 기록한다. 같은 제안이 다시 나오면(사람이든 AI의 `retro`든) 먼저 여기를 본다.

## 하네스 변경을 받는 기준
제안은 아래 두 가지를 모두 만족할 때만 `docs/improvements.md`에서 `APPROVED`가 된다.
1. **관찰된 실패**: 실제 세션에서 무엇을 했고, 하네스가 어떻게 동작했고, 무엇을 기대했는지가 있다. "있으면 좋겠다"는 해당하지 않는다.
2. **이 하네스의 방향과 맞음**: 아래 목록에 없고, 1인 개발자가 매일 쓰는 비용을 늘리지 않는다. 한 프로젝트에만 필요한 것은 `.harness/project/`에 둔다.

규칙을 **지우는** 제안도 같은 기준이다 (몇 주 동안 한 번도 쓰이지 않았다는 관찰).

## 파일 형식
제목(개념 한 줄) · 왜 넣지 않는가 · 대신 무엇을 하는가 · 다시 검토할 조건 · 이전 제안(날짜, 출처).

## 목록
- [orchestration-runtime.md](orchestration-runtime.md) — orchestration runtime, swarm, 에이전트 팀
- [state-db-and-learning-memory.md](state-db-and-learning-memory.md) — state DB, 벡터 기억, 자가 학습
- [event-and-cost-logging.md](event-and-cost-logging.md) — 이벤트·비용 로깅, 대시보드, 웹 UI
- [parallel-worktree-automation.md](parallel-worktree-automation.md) — 병렬 worktree 자동화
- [stop-hook-verification.md](stop-hook-verification.md) — Stop hook으로 검증 강제
- [scoring-rubric-and-feature-list.md](scoring-rubric-and-feature-list.md) — 점수 rubric, 기계 판독용 기능 목록
- [file-boundary-subagents.md](file-boundary-subagents.md) — 파일 경계별 구현 subagent
- [tech-skill-catalog.md](tech-skill-catalog.md) — 기술별 skill 다수, 범용 대형 팩
- [team-and-permission-systems.md](team-and-permission-systems.md) — 다인 협업 기능, 독립 Permission/Git 시스템
