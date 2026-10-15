# Roles

Role = 책임. 기술 지식은 Skill, 순서는 Workflow, 능력 수준은 Tier. 기술별 Agent는 만들지 않고 `Implementer + kotlin`처럼 조합한다.
모든 Role을 매번 쓰지 않는다. Triage 등급이 필요한 Role만 정한다.

| Role | 실행 위치 | 기본 Tier | 책임 | 제약 |
|---|---|---|---|---|
| Requirements Analyst | 메인 세션 (사용자와 대화) | STRONG | 인터뷰, 모호성/누락/edge case 탐색, PRD 초안 | 구현을 서두르지 않는다 |
| PRD Reviewer | subagent `prd-reviewer` | BALANCED | completeness·충돌·위험 검토, 개선 제안 | 요구사항과 자기 의견을 분리. 읽기 전용 |
| Architect | subagent `architect` | STRONG | 구조 설계, 기술 선택, trade-off, 영향 분석 | 구현하지 않는다. 읽기 전용 |
| Researcher | subagent `researcher` | BALANCED (단순 탐색은 FAST) | 저장소·문서·의존성 조사, 영향 범위 | 코드를 수정하지 않는다. 읽기 전용 |
| Implementer | 메인 세션 | BALANCED (다중 파일·복잡: STRONG) | 코드 수정, 테스트 작성 | 무관한 파일 수정 금지, 기존 abstraction 먼저 조사 |
| Reviewer | subagent `reviewer` | BALANCED (FULL의 Spec 축: STRONG) | Spec 축(요구사항·정확성·보안·테스트)과 Standards 축(`coding-standards.md`·구조·smell)을 분리해 검토 | Implementer의 설명을 전달받지 않는다 (입력: PRD/요청 + diff + 검증 결과). 코딩 규칙 적용은 구현자가 아니라 Reviewer 몫 |
| Debugger | subagent `debugger` | STRONG (충돌 가설: REASONING) | 증거 수집, 가설 생성/검증, root cause, 수정 제안 | 추측만으로 수정하지 않는다. 코드를 직접 고치지 않고 제안한다 |

## 독립성 규칙

- Reviewer는 **새 context**에서 실행한다. 입력은 요구사항(PRD 또는 원 요청), `git diff`(또는 변경 파일 목록), `.harness/verify` 결과뿐이다. Implementer가 "왜 이렇게 했는지" 설명을 붙이면 Reviewer가 끌려간다.
- Debugger의 결론은 메인 세션이 사실로 가정하지 않는다. Evidence를 보고 수정 전에 한 번 재현/검증한다.

## 출력 형식

모든 Role의 보고는 [handoff 형식](templates/handoff.md)을 따른다. Role별 추가 섹션만 아래에 둔다.

- Reviewer: `## Spec`과 `## Standards`로 나눈 `Findings`, 각각 `[BLOCKER] / [MAJOR] / [MINOR]`, 각 항목에 `file:line`과 근거
- Debugger: `Hypotheses` 표 (Hypothesis / Prediction / Evidence / Supported·Rejected), `Root Cause`
- Researcher: `Impact Map` (영향 파일·호출 관계), `Existing Abstractions`, `Codemap Updates` (codemap에 없거나 틀린, 오래 유효한 사실 — 없으면 "없음")
- PRD Reviewer: 개선 제안 표 (Problem / Impact / Recommendation / Trade-offs / Priority)
