# Requirements Engineering

흐름: Idea → Interview → Draft PRD → Deep Dive → Gap/Risk → Improvement Proposal → **User Decision Gate** → Final PRD → Handoff
적용: STANDARD(요약 PRD) / FULL(전체 PRD). LIGHT는 건너뛴다. 기존 PRD가 있으면 새로 쓰지 말고 [변경 절차](#요구사항-변경)로 간다.

Role: Requirements Analyst (메인, STRONG) → PRD Reviewer (subagent `prd-reviewer`, FULL 필수 / STANDARD 선택)

## 1. Interview

- 질문 영역: Business, Actors, Functional, Data, Concurrency, Failure, Security, Operational, UX. **프로젝트와 무관한 영역은 건너뛴다.**
- 우선순위별 처리:
  - CRITICAL(답에 따라 설계/핵심 동작이 달라짐): 반드시 질문
  - HIGH(architecture/security/data consistency): 가능하면 질문
  - MEDIUM: 기본값 제안, 필요할 때만 질문
  - LOW: 기본값을 정하고 묻지 않음 (Assumption으로 기록)
- 한 번에 **최대 5개**, CRITICAL/HIGH 우선, 각 질문에 선택지와 추천 기본값을 붙인다. 코드/문서에서 답을 찾을 수 있는 질문은 하지 않는다 (Researcher 먼저).
- **용어**: `docs/glossary.md`가 있으면 먼저 읽는다. 사용자가 용어집과 다른 뜻으로 쓰거나("용어집의 '취소'는 주문 전체인데, 부분 취소를 말하는 건가?"), 한 단어가 두 개념을 가리키면("계정 — 고객인가 로그인 사용자인가?") 바로 짚는다. 사용자의 설명이 코드와 어긋나면 그것도 짚는다. 사용자가 뜻을 정하면 그 자리에서 `docs/glossary.md`에 한 줄 기록한다 (파일이 없으면 이때 만든다).

## 2. Draft PRD → Deep Dive → Gap/Risk

- [prd 템플릿](../templates/prd.md)으로 `docs/prd/<slug>.md` 작성. Confirmed / Assumptions / Open Questions / Out of Scope를 **분리**한다.
- Deep Dive(`prd-reviewer`에 PRD 경로만 전달): Missing / Ambiguous / Conflicting / Risky. 동시 요청, 중복 요청, partial failure, 응답 유실, retry, 상태 전이, 데이터 불일치, 권한 오류 중 **해당하는 것만**.
- 개선 제안은 `Problem / Impact / Recommendation / Trade-offs / Priority` 형식으로 PRD의 **Proposals** 절에 쓴다. 사용자 요구사항과 섞지 않는다.

## 3. User Decision Gate

- 제안 각각에 `ACCEPT / REJECT / DEFER / NEEDS_DISCUSSION`를 사용자가 정한다. 표로 한 번에 받는다.
- ACCEPT된 것만 Final PRD에 반영한다. DEFER/REJECT는 Out of Scope 또는 Decisions에 이유와 함께 남긴다.
- Acceptance Criteria는 검증 가능한 문장으로 쓴다. AI가 제안한 수치는 `Proposed`로 표시하고 승인 후 `Confirmed`.

## 4. Final PRD → Handoff

- 사용자의 명시적 승인("확정", "OK" 등)이 있어야 `Status: FINAL`. 승인 전 구현 금지.
- Handoff: `.harness/state/current.md`에 PRD 경로, 등급, 다음 단계 한 줄. **새 세션에서 구현 시작을 권장**한다 (인터뷰 context는 구현에 필요 없다).
- 주요 결정은 `docs/decisions.md`에 한 줄 추가 (날짜, 결정, 이유). 아래 세 조건을 모두 만족하는 결정만 ADR 파일로 남긴다 ([memory](memory.md)).

## 요구사항 변경

PRD를 조용히 덮어쓰지 않는다. PRD의 **Change Log**에 추가한다: `Original / Changed / Reason / Impact / Affected Components / Affected Tests`. 구현이 진행 중이면 영향받는 테스트·코드를 목록화해서 사용자에게 알린 뒤 진행한다.
