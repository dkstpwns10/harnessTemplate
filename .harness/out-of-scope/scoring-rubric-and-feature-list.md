# 점수 rubric, 기계 판독용 기능 목록

**왜 넣지 않는가**: 8개 차원 0–2점 채점이나 진행률 숫자를 담은 `feature_list.json`은 매 작업마다 채울 양식을 늘린다. 점수는 판정을 대신하지 못하고, 숫자는 실제 상태와 쉽게 어긋난다.

**대신**: 판정은 근거 목록으로 — 완료 판정 보고(AC별 근거, VERIFY·EVIDENCE·INTEGRITY 줄, 리뷰 두 축). 진행 상태는 티켓 Status 세 가지(OPEN/IN PROGRESS/DONE). 리뷰의 범위 판정은 `INTEGRITY WARN: scope:`와 Spec 축이 맡는다.

**다시 검토할 조건**: 여러 기능의 진행을 외부 도구로 집계해야 할 때.

**이전 제안**: 2026-10-16, JieDannaChen/agent-harness 비교 (evaluator-rubric, feature_list.json).
