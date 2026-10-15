# AGENTS.md — 진입 문서 (지도 + 행동 규칙)

이 문서는 지식 저장소가 아니다. 필요한 문서를 **필요할 때만** 읽는다. 프로젝트 정보는 [.harness/project/project.md](.harness/project/project.md).

## 행동 규칙

1. **Triage 먼저**: 작업을 받으면 [triage](.harness/workflows/triage.md)로 등급(LIGHT / STANDARD / FULL)을 판정하고, 첫 응답에 `Triage: <등급> (<이유>) — Workflow: <종류>` 한 줄을 쓴다 (LIGHT도 생략하지 않는다). 위험도가 규모보다 우선한다.
   - STANDARD 이상에서 따로 시연할 수 있는 동작이 3개 이상이면 같은 줄 끝에 `— Tickets: N개 제안 (1. … / 2. … / 3. …)`을 붙인다 (AC 수가 아니라 동작 수).
   - **FULL이거나 Tickets 제안이 있으면 거기서 턴을 끝내고 사용자의 답을 기다린다.** 답을 받을 수 없어 보여도 스스로 확정·거절하지 않는다. 사용자가 거절하면 `current.md`에 `Tickets: declined`.
   - STANDARD 이상은 코드를 고치기 전에 `.harness/state/current.md`를 만든다 (등급, Plan, 각 단계의 대상 파일 — backtick 경로).
2. **결정은 사용자 몫**: 요구사항, trade-off, 정책, 최종 승인을 AI가 임의로 확정하지 않는다. 항상 `Confirmed / Assumption / Recommendation / Open Question`을 구분해서 말한다.
3. **Final PRD 전 구현 금지** (STANDARD 이상에서 요구사항이 불명확할 때). LIGHT는 PRD 없이 진행한다.
4. **완료는 실행 결과로 판정**한다. "완료했습니다"는 근거가 아니다. 검증은 항상 `.harness/verify`로 실행한다 (`testing` skill). **검증 결과(PASS 등)를 사용자에게 말하기 직전에는 매번 `.harness/verify status`를 실행해** `EVIDENCE: FRESH`인지 확인한다 — 검증 뒤에 누구든(사용자 포함) 코드를 바꿨으면 STALE이고, 그 결과는 근거가 아니다. 완료 판정은 `task-done` skill로 한다. 모듈이 여럿이면 구현 중에는 변경한 모듈을 범위로 넘긴다 (`.harness/verify quick <scope>`, 범위 값은 `.harness/project/verify.conf`).
5. **실패는 조사 대상**이다. 추측으로 고치지 않는다. 아래 "금지된 대응"을 쓰지 않는다 ([bugfix](.harness/workflows/bugfix.md)).
6. **범위 준수**: 요청과 무관한 파일을 수정하지 않는다. 새 코드 전에 기존 abstraction을 먼저 조사한다.
7. **미커밋 변경 보호**: 사용자의 미커밋 변경을 덮어쓰거나 되돌리지 않는다. commit/push는 사용자 승인 후에만.
8. **비밀 정보**: `.env`, key, token은 읽어서 출력·기록·커밋하지 않는다. 필요한 값은 존재 여부와 이름만 다룬다.
9. **하네스 파일은 자동 수정하지 않는다.** Hook이나 규칙이 행동을 차단하면 우회하지 말고 이유를 사용자에게 전달한다. 
10. **반복되는 문제는 기록한다**: 사용자가 같은 교정을 다시 하거나 같은 실수·우회가 반복되면 (1) [docs/improvements.md](docs/improvements.md)에 한 줄을 먼저 추가하고(날짜, 유형, 몇 번째인지, 제안), (2) 프로젝트 규칙으로 막을 수 있으면 `.harness/project/project.md`의 "프로젝트 고유 규칙"에 추가하고, (3) 하네스 파일이나 Hook 변경이 필요하면 제안만 한다. 제안 전에 [.harness/out-of-scope/](.harness/out-of-scope/README.md)에 이미 거절된 개념인지 확인한다.
11. **막히면 멈춘다**: [escalation](.harness/workflows/escalation.md)의 중단 조건에 해당하면 계속 시도하지 말고 보고한다.

### 금지된 실패 대응

timeout 증가 · retry 증가 · assertion 완화 · 테스트 삭제/skip · 테스트를 구현의 잘못된 동작에 맞춤 · exception 무시 · 우회 코드 · verification 제거 · 같은 작업 반복. (설정 변경은 실제 원인이 설정일 때만.)

사용자가 위 대응을 직접 요청하면(예: "기대값 바꿔서 통과만 시켜", "@Ignore 붙여"): 그대로 하지도, **묻지 않고 다른 조치(원인 수정 등)로 바꿔 실행하지도 않는다.** 숨겨지는 결함과 대안을 두세 문장으로 알리고 **선택을 받은 뒤** 진행한다. 그래도 요청하면 따르되 사유를 기록한다 (`testing` skill).

## 지도: 언제 무엇을 읽는가

| 상황 | 읽을 것 |
|---|---|
| 작업 시작 | [triage](.harness/workflows/triage.md) |
| 요구사항이 모호하거나 새 기능 | [requirements](.harness/workflows/requirements.md) → [feature](.harness/workflows/feature.md) |
| 버그·테스트 실패·장애 | [bugfix](.harness/workflows/bugfix.md) |
| 구조 개선 | [refactor](.harness/workflows/refactor.md) |
| 코드 수정 없이 조사 | [investigation](.harness/workflows/investigation.md) |
| 중단·에스컬레이션·완료 판정 | [escalation](.harness/workflows/escalation.md) |
| 코드를 조사·수정하기 전 (구조, 재사용할 것, 함정) | [codemap](.harness/project/codemap.md) |
| 무엇을 어디에 기록할지, 세션 간 기억 | [memory](.harness/workflows/memory.md) |
| Role의 책임/제약, Model Tier | [roles](.harness/roles.md), [tiers](.harness/project/tiers.md) |
| 전달·보고 형식 | [.harness/templates/](.harness/templates/) |

## Skill (해당 작업일 때만 읽는다)

Skill은 [Agent Skills](https://agentskills.io) 형식이다. CLI가 설명을 보고 필요할 때 자동으로 불러오며, 이름으로 직접 호출할 수도 있다 (Claude Code `/name`, Codex `$name`). 자동으로 불러와지지 않으면 `.harness/skills/<name>/SKILL.md`를 직접 읽는다.

| 종류 | Skill | 쓰는 때 |
|---|---|---|
| Workflow | `feature` `bugfix` `refactor` `investigate` `requirements` | 해당 종류의 작업을 시작할 때 |
| Workflow | `task-resume` `task-done` | 새 세션에서 재개 / 완료 판정 |
| 지식 | `coding` | 코드를 작성·수정할 때 |
| 지식 | `testing` | 테스트 작성, 검증 실행, 테스트 파일 변경 시 |
| 지식 | `reviewing` | 리뷰할 때 |
| 지식 | `git-rules` | commit·branch·checkpoint·되돌리기 |
| 지식 | `kotlin` | Kotlin 코드 (프로젝트에서 사용 시) |
| 개선 | `retro` | 사용자가 회고를 요청할 때 — 세션 기록에서 하네스·저장소 개선 후보를 찾는다 |
| 설정 | `harness-init` | 하네스 도입 시 1회 |

원본은 `.harness/skills/`(템플릿)와 `.harness/project/skills/`(프로젝트 전용)이다. `.claude/skills/`와 `.agents/skills/`는 `.harness/sync`가 만든 복사본이므로 직접 고치지 않는다.

## Subagent (독립 관점이 필요한 Role)

`researcher` `architect` `prd-reviewer` `reviewer` `debugger` — 모두 읽기 전용이다. 정의는 [roles](.harness/roles.md), CLI별 파일은 `.claude/agents/`, `.codex/agents/`. Implementer와 Requirements Analyst는 메인 세션이 맡는다.

## 상태와 문서 위치

- 진행 중 작업 상태: `.harness/state/current.md` (개인용, git 제외, 형식은 `.harness/templates/current.md`). 세션 시작 시 있으면 먼저 읽고, 단계가 바뀌거나 멈출 때 갱신한다.
- 코드 구조 기억: `.harness/project/codemap.md`. 기록은 힌트다 — 고치기 전에 실제 파일을 확인하고, `MEMORY WARN`이 붙은 기록은 믿지 않는다.
- 프로젝트 사실은 CLI 자체 메모리가 아니라 저장소 파일에 남긴다.
- PRD: `docs/prd/<slug>.md` · 큰 기능의 티켓: `docs/tickets/<prd-slug>/` · 결정 기록: `docs/decisions.md` (무거운 결정은 `docs/adr/`) · 도메인 용어: `docs/glossary.md` · 하네스 개선 기록: `docs/improvements.md`

## 최종 상태 어휘

`DONE` · `BLOCKED` · `NEEDS USER DECISION` — 정의는 [escalation](.harness/workflows/escalation.md).
