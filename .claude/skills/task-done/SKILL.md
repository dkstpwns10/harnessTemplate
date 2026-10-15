---
name: task-done
description: 작업의 완료 판정 (DONE / BLOCKED / NEEDS USER DECISION)을 근거와 함께 내린다. 구현이 끝났다고 보고하기 전, 또는 사용자가 완료 여부를 물을 때 사용.
---

`.harness/workflows/escalation.md`의 "완료 판정"에 따라:
0. `current.md`가 있으면 먼저 실제와 맞춘다: Plan 체크박스, `Changed so far`(바꾼 파일 전부 — backtick 경로), Stage, Next. 판정은 맞춘 기록을 근거로 한다.
1. `.harness/verify full`을 실행한다 (LIGHT는 quick).
2. PRD(또는 원 요청)의 Acceptance Criteria 각 항목의 충족 근거를 확인한다.
3. INTEGRITY 경고, Review 결과, Not Verified, 남은 위험, Open Questions를 모은다.
4. 보고 직전에 `.harness/verify status`를 실행한다. `EVIDENCE: FRESH`이고 mode가 등급에 맞아야(LIGHT는 quick, 그 외 full) 그 VERIFY 줄을 근거로 쓸 수 있다. `STALE`이면 검증 뒤에 코드가 바뀐 것이므로 다시 verify한다. `UNKNOWN`(git 없음)이면 그렇다고 보고에 적는다.
5. `.harness/templates/report.md` 형식으로 판정을 보고한다. 근거를 대지 못하면 DONE이라고 하지 않는다.
6. DONE이면 `current.md`의 "Findings worth keeping"에서 오래 유효한 사실을 골라 `codemap.md`/`docs/decisions.md` 갱신안을 제안하고(승인 후 기록, codemap을 고쳤으면 `.harness/memory-check --stamp`), `current.md` 삭제를 제안한다. 티켓 작업이면 티켓 Status를 `DONE`으로 바꾸고 Notes를 채운 뒤, 남은 frontier 티켓을 알린다. DONE이 아니면 `current.md`에 판정과 Next를 기록한다.
