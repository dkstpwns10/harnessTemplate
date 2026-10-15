---
name: bugfix
description: Bugfix / Failure Resolution Workflow (재현 → 증거 → 가설 검증 → root cause → 최소 수정 → 회귀 테스트). 버그, 테스트·빌드 실패, 검증 실패, 예상 밖 동작을 다룰 때 사용. 구현 중 발생한 실패에도 사용.
---

보고된 증상(인자 또는 직전 실패)에 대해:

1. `.harness/workflows/triage.md`로 등급을 한 줄 제시한다.
2. `.harness/workflows/bugfix.md`를 따른다. **재현 명령을 실행해 그 증상으로 실패하는 출력을 보이기 전에는 코드를 한 줄도 바꾸지 않는다** (LIGHT 포함). 보고에 "수정 전에는 실패했다"고 쓰려면 그 실행 출력이 이 세션에 있어야 한다 — 실행하지 않은 실패를 적지 않는다.
3. 금지된 대응(timeout/retry 증가, assertion 완화, 테스트 삭제 등)을 쓰지 않는다.
4. 중단 조건(`.harness/workflows/escalation.md`)에 해당하면 멈추고 보고한다.
5. 끝났다고 말하기 전에 `task-done` skill로 완료 판정을 한다 (같은 재현 명령이 이제 통과하는 출력 + `.harness/verify status` FRESH).
