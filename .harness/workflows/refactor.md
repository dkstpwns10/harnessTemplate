# Refactor Workflow

단계: Impact Analysis → Plan → Implementation → Regression → Review
핵심 제약: **외부 동작을 바꾸지 않는다.** 동작을 바꾸고 싶으면 Feature/Bugfix로 분리한다.

1. **Baseline 확인**: 시작 전 `.harness/verify full`이 통과해야 한다. 실패하면 [baseline](../project/baseline.md)과 비교해 보고하고 사용자 판단을 받는다.
2. **보호망 확인**: 리팩터링 대상에 테스트가 없으면 먼저 현재 동작을 고정하는 **characterization test**를 추가한다 (사용자에게 범위 보고). 보호망 없이 구조 변경 금지.
3. **Impact Analysis** (Researcher, 구조 변경이면 Architect): 영향 파일, 공개 API 사용처, 위험. 공개 계약에 닿으면 FULL.
4. **Plan**: 각 단계가 독립적으로 빌드·테스트 통과 가능한 작은 단위가 되도록 쪼갠다. 단계별 목적과 롤백 방법(해당 파일 목록) 기록.
5. **Implementation**: 한 단계 → quick verify → 다음. 기능 추가·버그 수정을 섞지 않는다. 테스트 수정은 import/이름 변경 같은 기계적 변경만 허용 — 기대값을 바꿔야 하면 중단하고 보고 (동작이 바뀐 것이다).
6. **Regression**: `.harness/verify full`. baseline 대비 새 실패 없음.
7. **Review**: STANDARD 이상은 `reviewer`에 "동작 보존 여부"를 중점 확인하도록 요청 (입력은 diff와 verify 결과).

실패 시 수정 위에 수정을 쌓지 않는다. 직전 단계 상태로 돌아가 [bugfix](bugfix.md) 절차로 원인을 찾는다 (`git-rules` skill의 복구 방법).
