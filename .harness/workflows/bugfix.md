# Bugfix / Failure Resolution

단계: Reproduction → Evidence → Hypothesis → Verification → Root Cause → Minimal Fix → Regression Test → 원래 실패 재현 확인 → Regression Verification → Review
검증 실패, 테스트 실패, 장애, 예상 밖 동작 **모두 이 절차**를 쓴다 (feature 구현 중 실패 포함).

## 1. Reproduction — 재현 명령 하나를 만든다

이 단계가 bugfix의 대부분이다. 버그에서 실패하는 명령이 있으면 원인은 찾게 되고, 없으면 코드를 아무리 읽어도 추측이다.

**완료 기준**: 아래를 모두 만족하는 **명령 하나**를 이름으로 댈 수 있고, **이미 한 번 실행해** 그 출력(비밀은 `<REDACTED>`)을 보였다. 이것이 없으면 2단계로 가지 않는다. 명령이 생기기 전에 코드를 읽으며 원인을 짐작하고 있다면 멈춘다.

- [ ] **증상에서 실패한다**: 실제 버그 경로를 지나고 사용자가 말한 증상 자체를 확인한다 ("에러 없이 끝남"이 아니라 "합계가 1001이어야 하는데 1000").
- [ ] **결정적이다**: 실행할 때마다 같은 판정 (flaky면 재현율을 고정해 적는다, 예: 200회 중 37회).
- [ ] **빠르다**: 초 단위. 느리면 범위·setup을 줄인다.
- [ ] **AI가 혼자 돌릴 수 있다**: 사람이 개입해야 하면 [hitl-loop.sh](../templates/hitl-loop.sh)를 복사해 절차를 스크립트로 만든다.

만드는 방법 (위에서부터): 실패하는 테스트 → HTTP/CLI 호출과 기대 출력 비교 → 실제 입력(요청·이벤트·로그)을 저장해 재생 → 문제 경로만 띄우는 임시 harness → 무작위 입력 반복(property/fuzz) → 두 버전·설정의 출력 비교 → `git bisect run`으로 돌릴 수 있는 판정 스크립트 → 사람 개입 스크립트(최후).

- 재현 명령은 `current.md`의 Findings에 그대로 적는다. 수정 후 같은 명령으로 확인한다 (5의 3).
- 재현 불가면 수정하지 않는다. 시도한 방법을 나열하고, 재현 환경 접근·로그 같은 증거·임시 계측 허락 중 무엇이 필요한지 사용자에게 묻는다 ([escalation](escalation.md)).
- 분류: **새 실패** vs [baseline](../project/baseline.md) 실패 vs flaky(재실행 결과가 달라짐) vs 환경 의존(네트워크·시간·순서·리소스).
- flaky/환경 의존도 retry로 덮지 않는다. 반복 실행·부하·타이밍 조절로 재현율을 올려 증거로 입증하고 사용자에게 보고한다.

## 2. Evidence
스택트레이스, 로그, 최근 변경(`git log`/`git diff`), 입력값, 환경. 긴 로그는 실패 부분만 인용한다. 복잡하면 `debugger` subagent에 Failure/재현 방법/관련 파일을 전달한다.

## 3. Hypothesis → Verification
가설마다 아래 표를 `current.md`(또는 debugger 보고)에 작성한다.

| Hypothesis | Prediction (맞다면 관찰될 것) | Experiment / Evidence | Result |
|---|---|---|---|
| … | … | 로그 추가, 최소 재현, 값 출력, bisect 등 | Supported / Rejected |

- 실험은 **코드를 고치지 않고** 관찰하는 것을 우선한다 (임시 로그는 되돌린다).
- 추측만으로 코드를 고치지 않는다.

## 4. Root Cause → Minimal Fix
- Root Cause를 **증거로** 한 문단 설명할 수 있어야 한다. 못 하면 5로 가지 말고 [escalation](escalation.md)을 확인한다.
- 수정은 그 원인을 직접 해결하는 최소 변경. 주변 정리 금지.

## 5. 완료 조건 (모두 충족)
1. root cause를 증거로 설명할 수 있다
2. 수정이 그 원인을 직접 해결한다
3. 처음 재현한 실패가 사라졌다 (같은 명령으로 확인)
4. 회귀 테스트를 추가했다 (버그를 재현하던 테스트가 곧 회귀 테스트)
5. `.harness/verify` 통과, 새 실패 없음

원인이 재발 가능한 구조적 함정이었다면 `codemap.md`의 "확인된 함정"에 추가를 제안한다.

## 금지된 대응
timeout/retry 증가 · assertion 완화 · 테스트 삭제/skip · 테스트를 잘못된 동작에 맞춤 · exception 삼키기 · 우회 코드 · verification 제거 · 동일 시도 반복. 설정 변경은 **원인이 설정임을 증거로 보인 경우**만.

## 등급
LIGHT(원인이 한눈에 보이는 단순 버그): 1,4,5만 엄격히, 가설 표는 한 줄. 재현 명령은 LIGHT에서도 생략하지 않는다. STANDARD: 전체 + Review. FULL(보안·데이터·동시성): 전체 + Debugger(REASONING 고려) + Reviewer 필수.
