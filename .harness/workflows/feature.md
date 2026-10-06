# Feature Workflow

단계: Requirements → Final PRD → Architecture → Research → Plan → Implementation → Verification → Review → Final Verification → 완료 판정
등급에 따라 단계를 생략한다 ([triage](triage.md)). 각 단계는 필요한 문서만 읽는다.

| # | 단계 | Role / Tier | 입력 → 산출 | 등급 |
|---|---|---|---|---|
| 1 | Requirements → Final PRD | Analyst / STRONG | [requirements](requirements.md) → `docs/prd/<slug>.md` (FINAL) | S: 요약 PRD, F: 전체 |
| 2 | Research | Researcher / BALANCED | PRD + codemap + 저장소 → 영향 파일, 기존 abstraction, 재사용 후보, codemap 갱신 후보 | S, F |
| 3 | Architecture | Architect / STRONG | PRD + Research 보고 → 구조 결정·trade-off (결정은 사용자 승인) | F, 또는 S에서 구조 변경 시 |
| 4 | Plan | 메인 / BALANCED | → `current.md`에 단계별 체크리스트 (각 단계에 검증 방법, 형식은 `templates/current.md`) | S, F |
| 5 | Implementation | Implementer / BALANCED~STRONG | Plan의 한 단계씩 구현 + 테스트 | 전체 |
| 6 | Verification (quick) | — | 한 단계 끝날 때마다 `.harness/verify quick [scope]` | 전체 |
| 7 | Review | Reviewer / BALANCED~STRONG | PRD + diff + verify 결과 → Findings | S, F |
| 8 | Final Verification | — | `.harness/verify full` | 전체 |
| 9 | 완료 판정 | 메인 | [escalation](escalation.md#완료-판정) | 전체 |

## FULL 등급의 필수 단계

FULL은 "생략 없음"이다. 변경이 작아 보여도 아래를 건너뛰지 않는다. 건너뛰려면 사용자에게 이유를 말하고 승인을 받아 `current.md`에 기록한다 ([triage](triage.md)의 축소 규칙).

1. `researcher`: 영향 범위와 재사용할 것 확인
2. `architect`: 설계안과 대안 → **사용자가 설계안을 승인한 뒤** 구현
3. `reviewer`: STRONG Tier로 호출 (Claude Code에서는 호출 시 `model`을 `.harness/project/tiers.md`의 STRONG 값으로 지정)

## 세션 경계 (권장)

- **1 → 4 / 5 이후는 새 세션**: Final PRD와 Plan이 파일로 남아 있으므로 인터뷰 대화는 버린다. 시작은 `task-resume` skill (Claude: `/task-resume`, Codex: `$task-resume`).
- 구현 중 context가 커졌으면 `current.md`를 갱신하고 새 세션에서 `task-resume`.
- 메인 context 보호를 위해 넓은 탐색(Research), 리뷰, 디버깅은 subagent에 맡기고 **보고서만** 받는다.

## 구현 규칙

- 한 번에 Plan의 한 단계. 각 단계마다 quick verify 통과 후 다음으로, 그리고 `current.md`의 체크리스트와 Next를 갱신한다.
- 새 코드를 쓰기 전에 Research 보고의 기존 abstraction을 먼저 확인한다.
- Plan에 없는 파일을 수정해야 하면 이유를 `current.md`에 적고 범위 확장이 큰 경우 사용자에게 알린다.
- 테스트를 바꿔야 할 때는 `testing` skill의 "테스트 변경 규칙"을 따른다.
- 검증이 실패하면 [bugfix](bugfix.md)의 Evidence/Hypothesis 절차로 간다. 수정→재실행을 반복하지 않는다.

## Review 단계 규칙

- `reviewer` subagent에게 **PRD 경로(또는 원 요청), 변경 파일 목록, verify 결과**만 전달한다. 구현 의도·설명은 붙이지 않는다.
- BLOCKER/MAJOR는 수정 후 재검증. MINOR는 사용자에게 목록으로 보고하고 처리 여부를 묻는다.
- Reviewer와 이견이 있으면 근거를 제시해 사용자에게 판단을 맡긴다 (Implementer가 임의로 기각하지 않는다).
