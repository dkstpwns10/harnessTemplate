# Model Tier 매핑 (프로젝트 소유)

Workflow와 Role 문서에는 Tier만 쓴다. 실제 모델과 effort는 여기서만 정한다.

| Tier | 용도 | Claude Code (`model` / `effort`) | Codex CLI (`model_reasoning_effort`) |
|---|---|---|---|
| FAST | 파일 검색, 분류, 단순 요약/변환 | `haiku` | `low` |
| BALANCED | 일반 구현·리뷰·문서·중간 분석 | `sonnet` | `medium` |
| STRONG | 복잡한 구현, 다중 파일, 디버깅, architecture | `opus` / `high` | `high` |
| REASONING | 동시성·분산·보안·migration·충돌하는 root cause | `opus` / `xhigh` | `xhigh` |

Codex의 `model`은 지정하지 않는다 (세션 모델을 상속). 모델을 고정하려면 `.codex/agents/*.toml`에 `model = "..."`을 추가한다.

## 적용 지점 (이 표를 바꾸면 함께 바꾼다)

| Role | Tier | Claude Code `.claude/agents/<role>.md` | Codex `.codex/agents/<role>.toml` |
|---|---|---|---|
| researcher | BALANCED | `model: sonnet` | `medium` |
| prd-reviewer | BALANCED | `model: sonnet` | `medium` |
| reviewer | BALANCED (FULL Spec 축은 호출 시 STRONG) | `model: sonnet` | `medium` |
| architect | STRONG | `model: opus`, `effort: high` | `high` |
| debugger | STRONG | `model: opus`, `effort: high` | `high` |

## 올리고 내리는 방법

- **한 번만 올리기 (Claude Code)**: subagent를 호출할 때 `model`을 지정하면 정의보다 우선한다 (예: reviewer를 FULL 등급에서 `opus`로). `effort`는 호출 시 바꿀 수 없으므로 REASONING이 필요하면 메인 세션에서 사용자가 effort를 올려 직접 다루거나, agent 파일의 `effort`를 `xhigh`로 바꾼다.
- **메인 세션**: 사용자가 모델과 effort를 고른다. 하네스는 "이 단계는 STRONG 권장"이라고 알릴 뿐 강제하지 않는다.
- 단순 탐색은 Claude Code 내장 `Explore` agent(FAST 상당)를 써도 된다.
- 4개가 과하면 REASONING을 STRONG에 합친다.
- 올리는 기준은 [escalation](../workflows/escalation.md). Tier가 높다고 context를 더 주지 않는다.
