# 중단 조건, Escalation, 완료 판정

## 중단 조건 (하나라도 해당하면 계속 시도하지 말고 멈춘다)

| 신호 | 예 |
|---|---|
| 같은 원인의 반복 실패 | 서로 다른 수정이 같은 에러로 2회 이상 실패 |
| 가설이 계속 기각됨 | 3개 가설이 연속 Rejected, 새 가설 근거 없음 |
| 증거 부족 | 재현 불가, 로그/접근권 없음 |
| 외부 의존 | 외부 서비스·계정·장비·시크릿 필요 |
| 결정 필요 | 요구사항 충돌, trade-off, 정책 |
| 권한/위험 | Hook·permission이 막은 행동이 필요, 되돌릴 수 없는 작업 |
| 범위 이탈 | 계획에 없는 모듈·계약 변경이 필요해짐 |
| Context 과대 | 같은 결론을 반복하거나 앞선 사실을 놓치기 시작함 |
| 진전 없음 | 최근 2회 시도가 새 정보를 만들지 못함 |

횟수(N)는 보조 신호일 뿐이다. 새 정보 없이 시도만 늘어나면 횟수와 무관하게 멈춘다.

## 상위 Tier로 올릴까, 사용자에게 넘길까

| 상황 | 선택 |
|---|---|
| root cause 불명, 가설 충돌, cross-module, 동시성/분산/보안 | **Tier 상향** (`debugger` STRONG→REASONING). 1회만. 올린 뒤에도 풀리지 않으면 사용자 |
| 정보·권한·결정이 없어서 막힘 | **즉시 사용자** (모델을 올려도 해결되지 않음) |
| 단순 실패 | 상향 금지. 증거부터 |

상향 시 전달: `Failure / Evidence / Changes Attempted / Rejected Hypotheses / Remaining Hypotheses / Relevant Files / Relevant Logs / Verification Results / Open Questions`. 전체 대화는 넘기지 않는다. 상위 Agent는 이전 결론을 사실로 가정하지 않고 필요하면 독립 검증한다.

## 중단 보고 형식

```
STATUS: BLOCKED | NEEDS USER DECISION
시도한 것:
실패한 것 (증거 포함):
현재 가장 유력한 가설:
검증하지 못한 것:
사용자가 결정/제공할 것: (선택지가 있으면 선택지와 추천)
```

## 완료 판정

판정자: **메인 세션이 아래 근거를 모두 제시하고 판정**하며, 최종 승인은 사용자 몫이다. 근거를 제시하지 못하면 DONE이 아니다.

| 입력 | 확인 |
|---|---|
| Acceptance Criteria | PRD의 각 항목 ↔ 충족 근거(테스트명/동작 확인). PRD가 없으면 원 요청 문장 단위로 대응 |
| Verification | `.harness/verify full` PASS (LIGHT는 quick PASS). 출력의 마지막 `VERIFY:` 줄 인용 |
| Integrity | `INTEGRITY` 경고가 있으면 정당성 근거 (아래) |
| Review | BLOCKER/MAJOR 없음 (해당 등급) |
| 남은 위험 / Not Verified / Open Questions | 모두 나열 |

- **DONE**: 위 전부 충족. Not Verified가 있어도 사용자가 인지할 수 있게 명시했고 핵심 요구사항 검증을 대체하지 않는 경우만.
- **BLOCKED**: 외부 요인·반복 실패·증거 부족으로 진행 불가 (중단 보고 첨부).
- **NEEDS USER DECISION**: 구현은 가능하나 요구사항·trade-off·정책 결정이 필요, 또는 AC 충족 여부가 판단 불가.
- 테스트가 통과해도 AC가 충족되지 않았거나 확인되지 않았으면 DONE이 아니다.

판정 보고는 [report 템플릿](../templates/report.md).
