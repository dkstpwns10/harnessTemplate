# 완료 판정 보고

```
STATUS: DONE | BLOCKED | NEEDS USER DECISION
Task / Triage / Workflow:

## Acceptance Criteria
| AC | 충족 | 근거 (테스트명 / 확인 방법) |

## Verification
VERIFY: (마지막 VERIFY 줄 그대로)
EVIDENCE: (`.harness/verify status`의 출력 그대로 — FRESH여야 한다)
INTEGRITY: (경고 목록과 각각의 정당성, 없으면 "경고 없음")
Baseline 대비 새 실패: 없음 | …

## Review
(수행 여부와 BLOCKER/MAJOR 처리 결과. LIGHT는 "자체 diff 점검")

## Changed Files

## Not Verified / 남은 위험 / Open Questions

## Workflow 축소 기록
(없으면 생략. 예: Downgraded FULL→STANDARD, accepted risk: …)

## Next
(사용자가 할 일: commit 여부, 결정 사항)
```

BLOCKED / NEEDS USER DECISION이면 [중단 보고 형식](../workflows/escalation.md#중단-보고-형식)을 함께 쓴다.
