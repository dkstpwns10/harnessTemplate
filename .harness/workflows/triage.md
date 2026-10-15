# Triage

Workflow는 작업의 **종류**(feature/bugfix/refactor/investigation), 등급은 그것을 **얼마나 깊게** 수행할지다. 등급은 단계를 생략·축약할 뿐 새 Workflow를 만들지 않는다.

## 등급

| | LIGHT | STANDARD | FULL |
|---|---|---|---|
| 판정 | 소수 파일, 동작이 명확, 위험 신호 없음 (오타, 작은 버그, 설정값, 문서) | 새 기능·동작 변경·다중 파일·원인 불명 버그 | **위험 신호가 하나라도** 있음 (아래) |
| 실행 | 구현 → quick verify | 요약 PRD(필요 시) → 계획 → 구현 → quick verify → Review → full verify | 전체 Workflow: 전체 PRD + PRD Reviewer + Architect + Researcher → … → Review → full verify |
| 생략 | PRD, Architecture, 별도 Review | Architecture(구조 변경 없으면), PRD Reviewer | 없음 |
| Tier | FAST~BALANCED | BALANCED~STRONG | STRONG~REASONING |
| Review | 본인 diff 점검 1회 | `reviewer` subagent (두 축을 한 번에) | `reviewer` 병렬 2회 필수: Spec(STRONG) + Standards(BALANCED) |
| Verification | quick (공유 코드를 건드렸다면 완료 전 full). 주석·문서만 바꿨으면 생략할 수 있고, 생략했다고 보고한다 | quick 반복 + 완료 전 full | full + 변경 영역 테스트 추가 확인 |

### 위험 신호 (하나라도 → 최소 FULL, 크기와 무관)

인증/권한 · 결제/금액 · 개인정보/비밀 · 데이터 마이그레이션/스키마 변경 · 동시성/트랜잭션/락 · 공개 API·이벤트 등 외부 계약 · 빌드/배포/CI 설정 · 3개 이상 모듈에 걸친 변경 · 되돌리기 어려운 데이터 변경

## 판정 방식 (AI 제안 + 사용자 정정)

1. AI가 한 줄로 제시한다: `Triage: STANDARD (다중 파일, 위험 신호 없음) — Workflow: feature`. 따로 시연할 수 있는 동작이 3개 이상이면 `— Tickets: 3개 제안 (1. … / 2. … / 3. …)`을 붙인다.
2. LIGHT/STANDARD는 정정이 없으면 바로 진행한다. **FULL이거나 Tickets 제안이 있으면 턴을 끝내고 답을 기다린다** (답이 없다고 스스로 확정하지 않는다).
3. 작업 도중 범위·위험이 커지면 멈추고 재판정을 알린다 (예: LIGHT 중 DB 스키마를 건드리게 됨 → FULL).
4. 등급과 Workflow를 `.harness/state/current.md`에 기록한다.

## 사용자가 Workflow 축소를 요청할 때

| 상황 | 대응 |
|---|---|
| 낮은 위험 | 그대로 허용. 기록은 선택 |
| 높은 위험 (위험 신호 있음) | 생략되는 검증과 구체적 위험을 한 문단으로 설명하고, 사용자의 명시적 승인을 받은 뒤 진행. `current.md`에 `Downgraded: FULL→STANDARD, accepted risk: …` 기록 |
| 명백히 위험 (예: 보안/데이터 변경에서 테스트·리뷰 전면 생략) | 이유 설명 + 대안(범위 축소, 테스트만 유지 등) 제시. 사용자가 명시적으로 재확인하면 위 "높은 위험"과 같이 기록하고 진행. 단 Hook이 막는 행동은 사용자가 직접 수행 |

## 원칙

- 판정 논의가 작업보다 길어지면 안 된다. 애매하면 한 단계 높게 잡고 사용자에게 한 줄로 물어본다.
- Triage는 사용자가 우회하고 싶어지는 첫 지점이다. 질문하지 말고 제시하라.
