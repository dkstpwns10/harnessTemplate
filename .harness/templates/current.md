# Current Task

`.harness/state/current.md`의 형식. 다음 세션이 이 파일만 읽고 이어갈 수 있어야 한다. 40줄 안팎으로 유지하고 대화 내용을 옮겨 적지 않는다.

```
# Current Task
- Task: (한 줄)
- Triage / Workflow: STANDARD / feature   (축소했다면: Downgraded FULL→STANDARD, accepted risk: …)
- PRD: docs/prd/<slug>.md (Status: FINAL) | 없음 (원 요청: "…")
- Ticket: docs/tickets/<prd-slug>/NN-<slug>.md | 없음 (큰 기능을 티켓으로 나눈 경우)
- Stage: (지금 단계)
- Updated: YYYY-MM-DD

## Plan
- [x] 1. … — `src/a/Foo.kt` (검증: …)
- [ ] 2. … — `src/a/` (디렉터리를 적으면 그 아래 전체)

(각 단계에 건드릴 파일·디렉터리를 backtick으로 적는다. `verify full`의 integrity-check가 여기·Pre-existing·Changed so far 어디에도 없는 변경 파일을 `scope:` 경고로 알린다.)

## Test seams
(STANDARD 이상에서 새 테스트를 쓸 때만. `seam` — 잡는 것 / 놓치는 것)

## Pre-existing changes
(작업 시작 시 이미 있던 미커밋 변경. 없으면 "없음")

## Changed so far
(내가 바꾼 파일을 backtick 경로로 — `src/a/Foo.kt`. backtick이 없으면 범위 검사·압축 후 대조가 경로로 인식하지 못한다)

## Findings worth keeping
(다음 세션에도 필요한 사실 + 근거 경로. 작업 종료 시 codemap/decisions 후보)

## Open questions / Blockers

## Next
(다음 행동 한 가지)
```
