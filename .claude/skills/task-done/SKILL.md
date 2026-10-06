---
name: task-done
description: 작업의 완료 판정 (DONE / BLOCKED / NEEDS USER DECISION)을 근거와 함께 내린다. 구현이 끝났다고 보고하기 전, 또는 사용자가 완료 여부를 물을 때 사용.
---

`.harness/workflows/escalation.md`의 "완료 판정"에 따라:
1. `.harness/verify full`을 실행한다 (LIGHT는 quick).
2. PRD(또는 원 요청)의 Acceptance Criteria 각 항목의 충족 근거를 확인한다.
3. INTEGRITY 경고, Review 결과, Not Verified, 남은 위험, Open Questions를 모은다.
4. `.harness/templates/report.md` 형식으로 판정을 보고한다. 근거를 대지 못하면 DONE이라고 하지 않는다.
5. DONE이면 `current.md`의 "Findings worth keeping"에서 오래 유효한 사실을 골라 `codemap.md`/`docs/decisions.md` 갱신안을 제안하고(승인 후 기록, codemap을 고쳤으면 `.harness/memory-check --stamp`), `current.md` 삭제를 제안한다. DONE이 아니면 `current.md`에 판정과 Next를 기록한다.
