---
name: task-resume
description: 새 세션에서 진행 중이던 하네스 작업을 .harness/state/current.md 로부터 재개한다. 사용자가 이어서 하자거나 이전 작업 재개를 요청할 때 사용.
---

1. `.harness/state/current.md`를 읽는다 (없으면 그렇다고 말하고 종료).
2. 거기 적힌 PRD/계획 파일과 `.harness/project/codemap.md`만 읽는다. 이전 대화는 없다고 가정한다.
3. `.harness/memory-check`를 실행하고 `git status`로 실제 변경 상태를 확인한다. `MEMORY WARN`이나 `current.md`와 어긋나는 점(적힌 파일이 없음, 체크된 단계의 변경이 보이지 않음, 적히지 않은 변경이 있음)이 있으면 먼저 알린다. "changed since" 경고가 이번 작업과 관련된 항목이면 그 codemap 항목을 실제 파일과 대조한 결과도 함께 알린다.
4. 현재 단계와 다음 행동 한 가지를 요약해 사용자 확인을 받은 뒤 이어서 진행한다.
