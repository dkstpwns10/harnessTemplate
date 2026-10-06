---
name: feature
description: Feature Workflow (Triage → Requirements → 설계 → 구현 → 검증 → 리뷰 → 완료 판정). 새 기능이나 동작 변경을 구현해 달라는 요청에 사용. 오타·설정값 같은 사소한 수정에는 쓰지 않는다.
---

사용자가 요청한 기능(이 skill 호출 시 함께 준 인자 또는 직전 요청)에 대해:

1. `.harness/workflows/triage.md`로 등급을 한 줄 제시한다 (FULL이면 사용자 확인을 기다린다).
2. `.harness/workflows/feature.md`를 읽고 등급에 맞는 단계만 수행한다. **FULL이면 `researcher` → `architect` → (설계안 사용자 승인) → 구현 → `reviewer`(STRONG) 를 모두 거친다.** 작아 보여도 임의로 건너뛰지 않는다 — 생략하려면 이유를 말하고 사용자 승인을 받아 `current.md`에 기록한다. 요구사항이 모호하면 `.harness/workflows/requirements.md`부터.
3. `.harness/state/current.md`에 등급, 계획, 진행 상태를 기록하고(형식: `.harness/templates/current.md`) 단계가 바뀔 때마다 갱신한다.
