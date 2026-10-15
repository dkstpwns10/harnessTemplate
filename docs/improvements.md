# Harness Improvements

하네스 개선 후보를 한 줄로 기록한다. **AI는 이 기록을 남기고 제안만 한다. 하네스 파일은 사용자 승인 후 수정한다.**
(수정 시 `HARNESS_UNLOCK=1`로 Claude Code를 실행하거나 사용자가 직접 편집)

기록 대상: 같은 실수 반복 · 같은 교정 반복 · Workflow가 불필요하게 김 · Skill 오작동 · Verification 누락 · 불필요한 escalation · **사용자가 하네스를 우회한 경우(이유)** · 삭제해도 될 규칙.

흐름: Repeated Problem → Pattern → Proposal → 사용자 승인 → Skill/Workflow/Rule/Verification 수정 (승인 시 Status를 APPLIED로)

받는 기준과 이미 거절된 개념: [.harness/out-of-scope/](../.harness/out-of-scope/README.md). 관찰된 실패가 없는 제안은 기록하지 않는다. 거절하면 그 개념을 out-of-scope에 파일로 남긴다.

| 날짜 | 유형 | 관찰 (몇 번째?) | 제안 | Status (OPEN/APPROVED/APPLIED/REJECTED) |
|---|---|---|---|---|
