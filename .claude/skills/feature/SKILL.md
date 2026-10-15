---
name: feature
description: Feature Workflow (Triage → Requirements → 설계 → 구현 → 검증 → 리뷰 → 완료 판정). 새 기능이나 동작 변경을 구현해 달라는 요청에 사용. 오타·설정값 같은 사소한 수정에는 쓰지 않는다.
---

사용자가 요청한 기능(이 skill 호출 시 함께 준 인자 또는 직전 요청)에 대해:

1. `.harness/workflows/triage.md`로 등급을 한 줄 제시한다 (FULL이면 사용자 확인을 기다린다).
2. **구현 전에** `.harness/state/current.md`를 만든다 (형식: `.harness/templates/current.md`): 등급, 계획, 각 단계의 대상 파일. 이후 단계가 바뀔 때마다 갱신한다. LIGHT도 등급과 바꿀 파일 한 줄은 적는다.
3. **티켓 분할 제안** (STANDARD 이상, AGENTS.md 규칙 1): 따로 시연할 수 있는 동작이 3개 이상이면 Triage 줄에 `— Tickets: N개 제안 (…)`을 붙이고 **턴을 끝내 답을 기다린다**. 받아들이면 `.harness/workflows/feature.md`의 "티켓 분할"대로, 사용자가 실제로 거절했을 때만 `current.md`에 `Tickets: declined`를 적고 한 번에 진행한다.
4. `.harness/workflows/feature.md`를 읽고 등급에 맞는 단계만 수행한다. **FULL이면 `researcher` → `architect` → (설계안 사용자 승인) → 구현 → `reviewer` 두 축 병렬(Spec은 STRONG) 을 모두 거친다.** 작아 보여도 임의로 건너뛰지 않는다 — 생략하려면 이유를 말하고 사용자 승인을 받아 `current.md`에 기록한다. 요구사항이 모호하면 `.harness/workflows/requirements.md`부터.
5. 끝났다고 말하기 전에 `task-done` skill로 완료 판정을 한다 (`.harness/verify status`가 FRESH인 full 검증이 근거).
