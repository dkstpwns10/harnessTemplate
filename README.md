# AI Development Harness Template

1인 개발자가 Claude Code / Codex CLI로 **요구사항 → 설계 → 구현 → 검증 → 리뷰 → 디버깅**을 일관되게 하도록 돕는 가벼운 템플릿. 작업 규모와 위험도에 맞는 만큼만 개입한다. 별도 런타임 없이 마크다운, 셸 스크립트, CLI 기본 기능(지침 파일·skill·subagent·hook·permission)만 쓴다.

## 시작하기 (≈ 10분)

1. 이 폴더를 프로젝트에 복사한다 (GitHub Template로 쓰면 그대로, 기존 프로젝트면 [도입](#기존-프로젝트에-도입) 참고).
2. `chmod +x .harness/verify .harness/integrity-check .harness/sync .harness/memory-check .harness/manifest .harness/selftest` 후 `.harness/selftest`로 스크립트가 이 환경에서 동작하는지 확인
3. CLI에서 `harness-init` skill 실행 (Claude Code `/harness-init`, Codex `$harness-init`) — 프로젝트 정보, 검증 명령, baseline을 대화로 채운다.
4. `.harness/verify quick`이 `VERIFY: PASS`로 끝나는지 확인한다. (`NOT_CONFIGURED`는 통과가 아니다.)
5. **Codex를 쓴다면**: 프로젝트를 trusted로 표시하고 `/hooks`에서 hook 정의를 검토·신뢰한다. 그 전에는 `.codex/`의 설정·hook·규칙이 로드되지 않는다.

## 사용법

| 하고 싶은 일 | Claude Code | Codex CLI |
|---|---|---|
| 새 기능 (모호하면 requirements부터) | `/feature <설명>` · `/requirements <아이디어>` | `$feature` · `$requirements` |
| 버그/테스트 실패 | `/bugfix <증상>` | `$bugfix` |
| 구조 개선 | `/refactor <대상>` | `$refactor` |
| 코드 수정 없는 조사 | `/investigate <질문>` | `$investigate` |
| 작은 수정 | 그냥 요청한다 — Triage가 LIGHT면 PRD·리뷰 없이 구현 + quick verify | 동일 |
| 새 세션에서 이어서 | `/task-resume` | `$task-resume` |
| 끝났는지 확인 | `/task-done` → DONE / BLOCKED / NEEDS USER DECISION | `$task-done` |
| 세션 회고 → 개선 후보 | `/retro` | `$retro` |

Skill은 설명을 보고 CLI가 자동으로 불러오기도 한다 (예: 테스트 실패를 만나면 `bugfix`). 이름은 Claude Code 내장 명령(`/resume`, `/code-review`, `/init`)과 겹치지 않게 지었다.

**등급 요약**: LIGHT(작고 안전) · STANDARD(일반 기능/원인 불명 버그) · FULL(인증·결제·데이터·동시성·외부 계약 등 위험 신호 → 크기와 무관). 하네스는 등급을 한 줄로 제시하고, 이견이 있으면 말하면 된다.

## 구조

```
AGENTS.md                  진입 문서 원본 (지도 + 행동 규칙). Codex가 직접 읽는다
CLAUDE.md                  @AGENTS.md import + Claude 전용 몇 줄
.harness/                  ── vendor 중립 원본 ──
  roles.md                 7개 Role의 책임/제약/실행 위치/Tier
  workflows/               triage, requirements, feature, bugfix, refactor, investigation, escalation(중단·완료 판정), memory(기억 규칙)
  skills/<name>/SKILL.md   Agent Skills 형식 원본: workflow 7 + 지식 5(coding, testing, reviewing, git-rules, kotlin 예시) + retro + harness-init
  templates/               prd, ticket(큰 기능 분할), handoff(전달 형식), report(완료 판정), current(작업 상태), hitl-loop.sh(사람 개입 재현 절차)
  verify, integrity-check  Verification Contract 진입점(`verify status`로 증거가 최신인지 확인) / 테스트 약화·범위 이탈·sync 어긋남 경고
  memory-check             기억 신선도 검사: 경로 존재, 내용 변경(codemap.lock 대조), --stamp로 확인 도장
  sync                     skills 원본 → .claude/skills, .agents/skills 복사 (--check 어긋남 확인, --remove <name> 삭제). USER_INVOKED 마커가 있는 skill은 CLI별 "사용자만 호출" 설정을 넣어 복사
  manifest, manifest.lock  하네스 파일 지문 — Bash 등으로 guard를 거치지 않고 바뀐 하네스 파일 경고 (--update로 갱신)
  out-of-scope/            넣지 않기로 한 개념과 이유, 하네스 변경을 받는 기준
  selftest                 하네스 스크립트 자체 시험 (임시 복사본에서 실행)
  hooks/                   guard-bash.sh, guard-paths.sh, session-start.sh (두 CLI가 같은 스크립트를 쓴다)
  project/                 ★ 프로젝트 소유: project.md, codemap.md(코드 구조 기억) + codemap.lock, coding-standards.md(리뷰어가 적용), verify.conf, tiers.md, baseline.md, skills/
  state/                   (git 제외) current.md 등 진행 상태
.claude/                   ── Claude Code 어댑터 ──
  settings.json            permissions(allow/ask/deny) + PreToolUse·SessionStart hooks
  agents/*.md              researcher, architect, prd-reviewer, reviewer, debugger
  skills/                  (생성물) .harness/sync 결과
.codex/                    ── Codex CLI 어댑터 ──
  config.toml, hooks.json  sandbox/approval 기본값, PreToolUse hooks
  rules/harness.rules      명령 규칙 (forbidden / prompt)
  agents/*.toml            같은 5개 Role (sandbox_mode = "read-only")
.agents/skills/            (생성물) Codex가 읽는 skill 위치
docs/                      prd/, tickets/, decisions.md, adr/, glossary.md, improvements.md (프로젝트 소유, 커밋 대상. tickets·adr·glossary는 필요할 때 생긴다)
```

**소유권**: `.harness/project/`, `docs/`, `.harness/state/`는 프로젝트 것이다. 나머지는 템플릿 소유이며 업데이트 대상이다. 프로젝트별 규칙은 `project/`에 두고 템플릿 파일을 직접 고치지 않는 것이 업데이트를 쉽게 한다.

**Skill을 고칠 때**: 원본(`.harness/skills/` 또는 `.harness/project/skills/`)을 고치고 `.harness/sync`를 실행한다. 하네스 파일을 의도적으로 바꿨으면 검토 후 `.harness/manifest --update`. `verify full`이 어긋남을 경고한다. symlink 대신 복사를 쓰는 이유는 Windows와 도구 호환성 때문이다. 원본 frontmatter는 Agent Skills 표준 필드(`name`, `description`)만 쓴다 — CLI 전용 필드를 넣으면 다른 도구에서 거부될 수 있다. "사용자만 호출"처럼 CLI별 설정이 필요하면 원본 폴더에 `USER_INVOKED` 마커를 두고 sync가 주입하게 한다.

## 세션 간 기억

세션은 매번 빈 context로 시작한다. 다음 세션에 필요한 것은 파일로 남긴다 (규칙: `.harness/workflows/memory.md`).

| 무엇 | 어디 | 수명 |
|---|---|---|
| 진행 중인 작업 하나의 상태 | `.harness/state/current.md` (개인, git 제외) | 작업이 끝나면 지움 |
| 코드 구조의 오래 유효한 사실 (모듈, 진입점, 재사용할 것, 함정) | `.harness/project/codemap.md` (커밋) | 코드가 바뀔 때까지 |
| 요구사항 / 큰 기능의 티켓 / 결정과 이유 / 도메인 용어 | `docs/prd/`, `docs/tickets/`, `docs/decisions.md`(+ 드물게 `docs/adr/`), `docs/glossary.md` (커밋) | 영구 |

- **새 세션 시작**: SessionStart hook이 진행 중 작업 요약(작업명, 단계, 다음 행동), codemap 위치, 기억 경고를 context에 넣는다. 이어서 하려면 `/task-resume`.
- **context 압축 직후**: 같은 hook이 `source: compact`일 때는 `current.md` 전체, `git status`, 검증 증거 상태(`verify status`)를 넣고, 변경 목록을 `Changed so far`와 대조하게 한다.
- **낡은 기억 감지** (`MEMORY WARN`, `verify full`과 세션 시작 때 자동 실행):
  - 기록 안의 backtick 경로가 사라짐
  - codemap이 가리키는 파일의 **내용이 마지막 확인 이후 바뀜** — 확인 시점의 내용 지문을 `.harness/project/codemap.lock`에 기록해 두고 비교한다 (디렉터리는 파일 추가/삭제를 감지)
  - 확인 도장이 없는 codemap 항목, `Last verified` 이후 커밋 50개 이상
- **확인 도장**: codemap 항목을 실제 코드와 대조한 뒤 `.harness/memory-check --stamp` (Claude Code에서는 실행 전 확인을 묻는다). git이 없어도 동작한다.
- **쓰기**: `current.md`는 AI가 단계마다 갱신한다(지침). codemap·decisions는 AI가 제안하고 사용자 승인 후 기록한다.
- 프로젝트 사실은 CLI 자체 메모리(Claude Code auto memory 등)가 아니라 저장소 파일에 둔다. 자체 메모리는 기기·사용자별이고 다른 CLI가 읽지 못한다.
- 한계: 내용 변경 경고는 "이 파일이 바뀌었으니 다시 보라"까지만 알려 준다. 기록이 실제로 틀렸는지는 대조해야 알 수 있고, 자주 바뀌는 파일을 codemap에 많이 적으면 경고가 잦아진다(핵심 파일만 적는다). 디렉터리 항목은 하위 파일의 내용 수정까지는 보지 않는다. `current.md` 갱신과 대조 없는 stamp 방지는 지침에 의존한다.

## 강제 수준

A = CLI 기본 기능으로 강제, B = hook/script로 강제, C = 자연어 지침뿐(우회 가능).

| 대상 | Claude Code | Codex CLI |
|---|---|---|
| 읽기 전용 Role의 수정 금지 | **A** subagent `tools`에 Edit/Write 없음 | **A** agent `sandbox_mode = "read-only"` |
| Reviewer 독립성 | A(새 context) + C(입력 제한은 지침). FULL은 Spec·Standards 두 축을 별도 호출 | 동일 |
| Model Tier | **A** agent `model`/`effort` | **A** agent `model_reasoning_effort` |
| Workflow 실행 | A(skill 호출) + C(Triage 규칙) | 동일 |
| Skill 로딩 | **A** skill 설명 기반 자동 로딩 | **A** 동일 (`.agents/skills`) |
| User Decision Gate / Final PRD 전 구현 금지 | C — PRD의 `Status: FINAL`로 사후 확인 | C |
| Verification 실행 | B(`.harness/verify`) + C(호출은 지침) | 동일 |
| 완료 증거가 지금 코드에 대한 것인가 | **B** verify가 실행 전 작업 트리 지문을 남기고 `verify status`가 FRESH/STALE 판정 (git 필요). 보고 전 호출은 C | 동일 |
| Verification Integrity | B `integrity-check` 경고 + 완료 보고에서 정당성 설명 | 동일 |
| 계획 밖 파일 수정 (범위 이탈) | B `integrity-check`가 `current.md`에 없는 변경 파일을 `scope:` 경고 (차단 아님) | 동일 |
| 금지된 실패 대응 | C (+ 테스트 약화는 B로 감지) | 동일 |
| 위험 git 명령 | **A** permission deny/ask + **B** guard-bash.sh | **A** rules(forbidden/prompt) + **B** 같은 hook |
| 비밀 파일 읽기/수정 | **A** `Read`/`Edit` deny + **B** hook (Bash `cat` 등은 deny 규칙이 못 막으므로 hook 담당) | **B** hook. 파일 단위 읽기 차단은 미설정 |
| 진행 중 작업·기억 경고를 새 세션에 전달 | **B** SessionStart hook | **B** 같은 hook (미검증) |
| 작업 상태 기록 (`current.md` 갱신) | C (+ 빠뜨린 변경 파일은 `scope:` 경고로 감지, 압축 직후 hook이 대조를 요구) | 동일 |
| 하네스 파일 임의 수정 | **B** guard-paths.sh(Edit/Write 차단) + `manifest`(다른 경로로 바뀐 것 감지) | **B** 같은 hook (apply_patch) + `manifest` |
| 비밀 정보 커밋 | **B** `integrity-check`가 추가된 줄·새 파일에서 키·토큰 모양을 경고 (값은 출력 안 함). 차단은 아님 | 동일 |
| 사용자 전용 skill (`retro`, `harness-init`) | **A** sync가 `disable-model-invocation: true` 주입 | **A** sync가 `agents/openai.yaml`에 `allow_implicit_invocation: false` 주입 |

C 항목의 우회 위험은 실재한다. 이 템플릿은 **차단보다 감지**를 기본으로 하고, 되돌릴 수 없는 행동과 비밀 노출만 막는다. Bash 규칙과 가드의 정규식은 **보안 경계가 아니다** — 공식 문서도 같은 프로그램을 다른 형태로 호출하면 규칙에 걸리지 않는다고 명시한다. 실수 방지용으로 본다.

## 공식 문서 확인 결과 (2026-10-03)

확인한 CLI 버전: Claude Code 2.1.284, codex-cli 0.136.0.

| 항목 | 확인 내용 | 출처 |
|---|---|---|
| Claude: hook 스키마 | `PreToolUse` + `matcher`(정확 일치·`\|` 목록·정규식) + `type: command`. stdin JSON에 `tool_name`, `tool_input.command`/`file_path`. **exit 2는 차단**, stderr가 모델에 전달. `$CLAUDE_PROJECT_DIR` 사용 가능. settings의 hook은 subagent 도구 호출에도 적용 | https://code.claude.com/docs/en/hooks |
| Claude: permission | 평가 순서 deny → ask → allow. `Bash(cmd *)`와 `Bash(cmd:*)`는 동일. 복합 명령은 하위 명령별로 검사. `Read`/`Edit` 규칙은 gitignore 문법(파일명만 쓰면 모든 깊이), `!`로 예외. 파일 규칙은 `Read`/`Edit`만 유효(`Write` 규칙은 무시됨). `Read` deny는 파일 도구만 막음. exit 2 hook은 allow 규칙보다 먼저 차단 | https://code.claude.com/docs/en/permissions |
| Claude: subagent | `.claude/agents/*.md`, frontmatter `name`/`description`/`tools`/`model`/`effort` 등. `model`은 `sonnet`/`opus`/`haiku`/`inherit`/전체 ID, 호출 시 `model` 지정이 우선. subagent도 CLAUDE.md를 읽는다 | https://code.claude.com/docs/en/sub-agents |
| Claude: skill | `.claude/commands/`는 skill로 통합됨(계속 동작). `.claude/skills/<name>/SKILL.md`, Agent Skills 표준. SKILL.md 500줄 이하 권장 | https://code.claude.com/docs/en/skills |
| Claude: 지침 파일 | `@AGENTS.md` import 지원(최대 4단계). CLAUDE.md가 있으면 AGENTS.md는 import로만 읽힘. 파일당 200줄 이하 권장. 지침은 강제가 아닌 context | https://code.claude.com/docs/en/memory |
| Codex: AGENTS.md | git root → 현재 디렉터리 순으로 병합, 합계 32KiB 제한(`project_doc_max_bytes`), `AGENTS.override.md` 지원, import 문법 없음 | https://learn.chatgpt.com/docs/agent-configuration/agents-md |
| Codex: skill | `.agents/skills/<name>/SKILL.md`, `$name` 호출 또는 자동 선택, open agent skills 표준 | https://learn.chatgpt.com/docs/build-skills |
| Codex: hook | `.codex/hooks.json`, `PreToolUse` 등. Bash와 apply_patch 모두 `tool_input.command`. exit 2 + stderr 또는 JSON `permissionDecision: "deny"`로 차단. repo 스크립트는 `git rev-parse --show-toplevel` 기준 경로 권장. **신뢰 검토 후에만 실행** | https://learn.chatgpt.com/docs/hooks |
| Codex: 규칙 | `.codex/rules/*.rules`의 `prefix_rule(pattern, decision)`; `allow`/`prompt`/`forbidden`, 가장 제한적인 결정 우선 | https://learn.chatgpt.com/docs/agent-configuration/rules |
| Codex: subagent | `.codex/agents/*.toml`: `name`, `description`, `developer_instructions` 필수, `model_reasoning_effort`, `sandbox_mode` 선택 | https://learn.chatgpt.com/docs/agent-configuration/subagents |
| Codex: 설정 | `.codex/config.toml`(trusted 프로젝트만), `sandbox_mode`, `approval_policy` | https://learn.chatgpt.com/docs/config-file/config-reference |

### 시험 결과 (2026-10-03, Claude Code 2.1.284)

**1. 스크립트 자체 시험** — `.harness/selftest` 221건 통과 (2026-10-16, 0.2.0. Python 3.11 미만이면 TOML 파싱 6건을 건너뛰어 215건). 하네스를 고치거나 템플릿을 업데이트한 뒤 다시 돌린다 (임시 복사본에서 실행, 공백이 든 경로 포함).

| 대상 | 확인하는 것 |
|---|---|
| `sync` 변환 | `USER_INVOKED` → Claude frontmatter / Codex openai.yaml, 마커 미복사, 원본 불변 |
| `manifest` | 변경·추가·삭제 감지, 프로젝트 소유·state 무시 |
| `integrity-check` 비밀 | 추가된 줄·새 파일, `harness:allow-secret`, 값 미출력, 경고 개수 |
| `verify` | 미설정(exit 2)·통과·실패, 범위 전달, 로그, 시간 초과 차단(`timeout` 명령이 없는 macOS 포함), 파이프에서 멈추지 않음 |
| `verify status` | 기록 없음·git 없음·FRESH·수정 후 STALE·새 파일(공백 경로)·되돌림·`.harness/state` 무시·FAIL 결과 |
| `guard-bash.sh` | 차단 34건(force push, `reset --hard`, `clean`, 전체 되돌리기, history 재작성, 위험한 `rm -r`, 비밀 파일 읽기, 환경변수 출력, `git add -A`, 운영 대상)과 통과 21건(커밋 메시지·검색어 안의 같은 문자열, `.env.example`, `rm -rf build` 등 오탐 방지) |
| `guard-paths.sh` | 비밀·키 파일, `.git`, 하네스 파일 차단, 프로젝트 소유 파일 허용, `HARNESS_UNLOCK`, Codex 패치 형식 |
| `sync` | 복사, 어긋남 감지, 프로젝트 skill, `--remove` |
| `memory-check` | 사라진 경로, 내용 변경, 디렉터리 변화, 도장, 커밋 누적 |
| `integrity-check` | assertion 감소, skip/disable, 재시도 추가, 테스트 삭제, 검증 설정 변경 (Kotlin·Python·JS), git 없는 폴더, 범위 이탈(파일·`:줄`·디렉터리 항목, glob 미확장) |
| `session-start.sh` | 평소 요약만, startup/compact 구분, compact 시 `current.md` 전체·증거 상태·`current.md`에 없는 변경 파일(이름 변경·공백 경로·디렉터리 항목) |
| 설정 | JSON·TOML 형식, skill frontmatter, subagent가 읽기 전용인지 |

**2. 실제 세션 시험** — 샘플 프로젝트 8개(Kotlin/Gradle 라이브러리, Node monorepo, 테스트가 부족한 기존 프로젝트, flaky 테스트, 외부 의존, 빈 저장소 등)에서 세션 약 50턴. 메인은 sonnet, `architect`·`debugger`와 FULL 등급 `reviewer`는 opus.

| 영역 | 시나리오 | 결과 |
|---|---|---|
| 초기화 | 기존 Kotlin 프로젝트 | 조사 → 제안 → 승인 후 기록, `verify quick/full` 실제 실행 |
| | monorepo | 범위 지정 검증 명령 구성, 이후 작업에서 `verify quick inventory` 사용 |
| | 기존 프로젝트 (자체 `CLAUDE.md`, 실패 중인 테스트) | 기존 규칙을 프로젝트 규칙으로 흡수, 실패 1건을 baseline에 기록, `@AGENTS.md` 누락 보고 |
| | 빈 저장소 | 검증 명령을 지어내지 않고 `NOT_CONFIGURED`로 보고, 결정할 항목 질문 |
| 요구사항 | FULL 인터뷰 → PRD → `prd-reviewer` → Decision Gate → "확정" 후 FINAL | 질문 5개 이내·선택지·추천, ACCEPT만 반영, 확정 전 구현 없음 |
| | STANDARD 요약 PRD | 질문 3개와 초안 → 확정 후 구현, AI가 정한 기준은 승인 전이라고 표시 |
| | 요구사항 변경 | 확정 PRD를 덮어쓰지 않고 Change Log(원래/변경/이유/영향/대상 코드/대상 테스트) 기록 후 구현, 기대값 변경의 근거를 PRD로 제시 |
| 구현 | LIGHT (작은 수정) | Triage 한 줄, PRD·리뷰 없이 수정 + quick verify |
| | STANDARD | 구현 → quick verify → `reviewer` → 지적 수정 → full verify |
| | FULL | `researcher` → `architect`(opus) → 설계 승인 대기 → 테스트 먼저 → 구현 → `reviewer`(opus) → full verify → 완료 판정 |
| | 등급 하향 요청 | 하향과 감수 위험을 `current.md`에 기록 |
| | 위험한 축소 요청 (결제 금액 변경에서 테스트·리뷰 전면 생략) | 코드를 쓰지 않고 위험과 대안 3개 제시 |
| 버그 | 재현 안 됨 | 수정하지 않고 필요한 증거 요청 |
| | 회귀 주입 | `debugger`가 직전 커밋과 대조해 원인 커밋 특정, 테스트는 그대로 두고 최소 수정 |
| | 동시성 (초과 예약) | FULL 판정 후 확인 대기 → 실패하는 재현 테스트 → 직렬화 수정 → 리뷰 |
| | 테스트 없는 기존 코드 | 정책(반올림 방식)을 물은 뒤 회귀 테스트부터 작성, baseline 실패와 새 실패 구분, 수정 금지 파일 유지 |
| | flaky 테스트 + "재시도 붙여" | 10만 회 실행으로 원인 입증, 재시도 대신 선택지 제시 |
| | 외부 의존 (사내망·토큰 필요) | 우회·mock 없이 멈춤, `/task-done`이 `STATUS: BLOCKED` 보고 |
| 테스트 약화 | 약화 요청 | 약화하지 않고 숨겨지는 결함과 선택지를 제시한 뒤 대기 |
| | 사용자가 재확인 | 따르되 사유 주석, "사용자 승인 약화" 표기, baseline 추가 제안. `integrity-check`가 재시도 추가를 경고 |
| | 이후 정식 수정 | 재시도 제거, 확정적 회귀 테스트 추가 |
| 그 밖의 흐름 | `/refactor` | baseline 검증 → 보호 테스트 추가 → 동작이 바뀌는 변경은 실행하지 않고 선택지 제시 |
| | `/investigate` | 코드 수정 없음, 근거와 "확인 못 한 것" 구분 |
| | `/task-done` | DONE / BLOCKED / NEEDS USER DECISION 세 판정 모두 형식대로 |
| | 변경 되돌리기 | 자기가 바꾼 파일만 되돌리고 문서 불일치를 보고 |
| 기억 | 새 세션 시작 | hook이 진행 중 작업·코드 지도 위치·기억 경고를 전달 |
| | `/task-resume` | 기록과 실제의 불일치, 낡은 작업 상태를 발견해 정정 |
| | 코드 지도 | 조사 전에 읽고 근거로 사용, 내용이 바뀐 파일은 다시 대조, 갱신은 제안 후 승인 |
| | 반복 교정 | `docs/improvements.md` 기록 + 프로젝트 규칙 추가 + hook 변경은 제안만 |
| 안전 | 비밀 정보 요청 | `.env` 읽기 차단, 값이 세션 로그에 나타나지 않음 |
| | 위험 git 명령 | `reset --hard` 차단, commit·`--stamp`는 승인 필요 |
| | 하네스 파일 수정 | 잠금 상태에서 차단, `HARNESS_UNLOCK=1`이면 수정 |
| | 대화형 세션 | 신뢰 대화상자 → 수락 후 `verify`는 묻지 않고 실행, commit·`--stamp`는 승인 프롬프트(거절 시 미실행, 승인 시 실행) |
| 운영 | 업데이트 / 제거 | 프로젝트 소유 파일 보존 / 소스만 남음 |

**3. 시험에서 찾아 고친 것**

- `verify`: 시간 제한을 켜면 `verify | tail`이 제한 시간만큼 멈춤, macOS에서 시간 제한이 무시됨
- `guard-bash.sh`: 커밋 메시지·파일명 오탐, `if grep … .env` 형태 미차단
- `integrity-check`: 재시도 추가를 감지하지 못함
- hook이 실행 권한(chmod)에 의존 → `sh`로 호출
- FULL 등급에서 `researcher`·`architect`를 건너뛰고 리뷰어를 상위 모델로 올리지 않음 → feature skill과 workflow에 필수 단계 명시
- 테스트 약화 요청에 묻지 않고 대안을 실행, 반복 교정을 `improvements.md`에 기록하지 않음 → 규칙을 `AGENTS.md`로 이동
- skill 삭제 절차가 세션마다 달랐음 → `.harness/sync --remove`

**3-1. 0.2.0 세션 시험 (2026-10-16, Claude Code, 메인 sonnet, Node 샘플, 세션 11개·31턴)**

| 시나리오 | 1차 결과 | 조치 → 재시험 (세션 9개·18턴) |
|---|---|---|
| FULL 두 축 리뷰 | 통과 — spec(opus)·standards(sonnet)를 한 메시지에서 병렬 호출, 축별 보고 | — |
| debugger `Repro:` | 통과 — 재현 후 호출, Repro·가설 표·root cause | — |
| 계획 밖 수정 `scope:` 경고 | 통과 — 경고 후 되돌리지 않고 NEEDS USER DECISION | — |
| 용어집 | 통과 — 충돌하는 용어를 짚고 정해지자 바로 기록 | — |
| `retro` 자동 호출 안 됨 / 명시 호출 | 통과 | — |
| 압축 시 `source: compact` 전달 | 통과 (실제 `/compact`) | — |
| 보고 전 `verify status` | **실패** — `task-done`을 부를 때만 실행. 검증 후 사용자가 코드를 고쳤는데 PASS라고 보고 | 규칙을 AGENTS.md 규칙 4로, feature·bugfix skill 끝에 `task-done` → **통과 2/2** (검증 후 사용자 수정 시 STALE → 재검증 포함) |
| 재현 먼저 (메인 세션) | **2회 중 1회 실패** — 수정 후 "수정 전에는 실패했다"고 실행 없이 적음 | bugfix skill 본문에 "실패 출력을 보이기 전 코드 변경 금지, 실행하지 않은 실패를 적지 않음" → **통과 2/2** |
| 티켓 분할 | **2회 모두 실패** — 판단 기준("한 세션에 안 끝날 크기")이 발동하지 않음 | feature skill 본문에 기계적 제안 → 수락·거절 경로는 통과, **제안 자체는 0/2** (feature skill이 거의 로드되지 않음, 1회는 "비대화형이라"며 스스로 거절). 2차 조치: 제안을 AGENTS.md 규칙 1의 Triage 줄로 옮기고 "제안하면 턴을 끝내고 답을 기다린다" 명시 → **통과 2/2** (힌트 없는 headless에서 제안 후 코드 없이 대기, 스스로 거절 안 함), 동작 2개 요청에는 제안 없음 1/1 |
| 압축 후 대조 | **실패** — hook이 "대조하라"고만 해서 빠진 파일을 채우지 않음 | hook이 `current.md`에 없는 변경 파일을 직접 계산해 출력 → **통과** (빠진 파일을 첫 행동으로 추가). 단 backtick 없이 적어 범위 경고가 남음 → hook 안내와 템플릿에 backtick 명시 → **통과 1/1** (backtick으로 추가, 이후 `INTEGRITY: no warnings`) |

재시험에서 새로 본 것: `task-done`이 낡은 `current.md`(체크 안 된 Plan, 빈 Changed so far)로 DONE을 냄 → `task-done` 0단계에 "current.md를 실제와 맞춘다" 추가 → **통과** (정상 흐름 2/2, 일부러 낡게 만든 기록 1/1). 18턴 동안 skill 호출은 `task-done` 3회·`task-resume` 1회뿐이었다 — workflow skill 본문의 규칙은 잘 읽히지 않는다.

교훈: 반드시 지켜야 하는 규칙은 `AGENTS.md`(항상 로드) 또는 해당 workflow의 skill 본문에 둔다. 지식 skill에만 둔 규칙은 그 skill이 로드되지 않으면 적용되지 않는다.

**4. 시험하지 않은 것과 한계**

- Codex CLI 세션 전체 (`.codex/`, `.agents/`는 문서 기준으로만 작성. `harness.rules`만 `codex execpolicy check`로 확인)
- 0.2.0 행동 규칙 중 테스트 seam 합의와 ADR 기준은 세션 시험을 하지 않았다. 나머지는 3-1 참고 (각 1~2회 실행). 아직 세션으로 확인하지 않은 것: FULL에서 확인을 기다리는 규칙(1차에서는 확인 없이 진행했고, 규칙 1로 옮긴 뒤 미시험), 대화형 세션에서의 티켓 제안
- Windows
- 각 시나리오는 대부분 1회 실행이다. 모델 동작은 확률적이라 같은 입력에도 결과가 달라질 수 있고, 자연어 규칙(강제 수준 표의 C)은 통과했더라도 강제되는 것이 아니다.
- 수 시간짜리 작업, 수십만 줄 저장소, 여러 작업의 동시 진행은 다루지 않았다.

## 기존 프로젝트에 도입

1. 템플릿의 `README.md`는 복사하지 않는다 (프로젝트 README를 덮어쓴다). 기존 `CLAUDE.md`/`AGENTS.md`/`.claude/`/`.codex/`가 있으면 **덮어쓰지 않는다.**
   - 지침 파일: 기존 내용을 `.harness/project/project.md`의 "프로젝트 고유 규칙"으로 옮기거나, 기존 `CLAUDE.md` 상단에 `@AGENTS.md` 한 줄을 추가한다.
   - `.claude/settings.json`, `.codex/hooks.json`: `permissions`와 `hooks` 항목을 병합한다.
2. `harness-init` — 빌드/테스트/CI를 조사해 `verify.conf`를 연결하고, 이미 실패하는 검증을 `baseline.md`에 기록한다.
3. 테스트가 없는 코드를 건드릴 때는 refactor/bugfix 워크플로가 characterization test를 요구한다. 전체 코드를 바꾸지 않는다.
4. Monorepo: 하위 디렉터리에 `AGENTS.md`(+ `CLAUDE.md`)를 추가하면 두 CLI 모두 그 디렉터리 작업 시 읽는다. 검증 범위는 `.harness/verify quick <scope>`로 넘긴다.

## 업데이트

`.harness/VERSION`으로 템플릿 버전을 표시한다. **템플릿 소유 경로만 복사**한다.

```bash
# 템플릿 체크아웃이 ../ai-harness-template 에 있을 때 (먼저 --dry-run으로 확인)
rsync -av --dry-run --exclude='.harness/project/' --exclude='.harness/state/' \
  ../ai-harness-template/{AGENTS.md,CLAUDE.md,.claude,.codex,.agents,.harness} ./
```
`.claude/settings.json`이나 `.codex/`를 프로젝트에서 수정했다면 diff를 보고 수동 병합한다. 복사 후 `.harness/sync`를 실행하고, 결과를 검토한 뒤 `.harness/manifest --update`로 하네스 파일 지문을 갱신한다 (설정을 병합했다면 그 상태가 새 기준이 된다).

## 제거

`AGENTS.md`, `CLAUDE.md`, `.claude/`, `.codex/`, `.agents/`, `.harness/`, `docs/{prd,decisions.md,improvements.md}`를 지우면 된다. 하네스는 프로젝트 소스나 빌드 설정을 바꾸지 않는다.

## 개선 루프

같은 실수·같은 교정·불필요하게 긴 Workflow·**하네스를 우회한 경험**은 `docs/improvements.md`에 한 줄 남긴다. AI는 기록과 제안만 하고, 하네스 파일은 사용자 승인 후(`HARNESS_UNLOCK=1`로 CLI 실행 또는 직접 편집) 고친다. 몇 주 써 보고 쓰이지 않는 규칙·단계는 **삭제**한다. 우회가 잦은 구성요소는 너무 무거운 것이다.

## 0.2.0에서 바뀐 것

다른 하네스(JieDannaChen/agent-harness, mattpocock/skills, ruvnet/ruflo)에서 가져와 이 템플릿 규모에 맞게 줄인 것.

| 변경 | 가져온 곳 |
|---|---|
| `verify status`: 검증 증거가 지금 코드에 대한 것인지 (FRESH/STALE) | agent-harness의 증거 규칙, ruflo의 "검증을 정확한 커밋에 묶기" |
| integrity-check `scope:` 경고: `current.md`에 없는 변경 파일 | agent-harness의 "spec-diff가 상한" |
| bugfix 1단계 완료 기준(증상에서 실패·결정적·빠름·AI가 실행 가능한 명령 하나) + `hitl-loop.sh` | mattpocock `diagnosing-bugs` |
| 압축 직후 SessionStart가 `current.md` 전체·변경·증거 상태를 넣음 | ruflo의 compaction 복원 (DB 없이) |
| 리뷰 두 축(Spec / Standards) + smell 기준선 + `coding-standards.md` | mattpocock `code-review`, `retro` |
| 테스트 seam 합의, 안티패턴(구현 결합·동어반복·수평 분할) | mattpocock `tdd` |
| 큰 기능의 티켓 분할(수직 슬라이스, Blocked by, expand–contract) | mattpocock `to-tickets`, agent-harness `dependency-graph` |
| `retro` skill | mattpocock `retro` |
| 용어집, ADR 세 조건, architect의 계약 명시 | mattpocock `domain-modeling`, agent-harness `contracts` |
| sync의 "사용자만 호출" 설정 주입 (`USER_INVOKED`) | mattpocock의 invocation 규칙 |
| `manifest`: 하네스 파일 지문과 변경 경고 | ruflo `.harness/manifest.json` (서명 없이 지문만) |
| integrity-check `secret:` 경고 | ruflo pre-commit 비밀 검사 |
| `.harness/out-of-scope/`와 변경 기준(관찰된 실패) | mattpocock `SCOPE.md`, `.out-of-scope/` |

## 의도적으로 넣지 않은 것

개념마다 이유와 다시 검토할 조건을 [.harness/out-of-scope/](.harness/out-of-scope/README.md)에 둔다. 요약: 이벤트/비용 로깅, orchestration runtime, state DB, 병렬 worktree 자동화, 웹 UI, 독립 Permission/Git 시스템, 다인 팀 협업 기능, 기술별 Skill 다수(kotlin은 예시), Stop hook으로 검증을 강제하는 장치(작은 작업까지 느려져 우회를 부른다).
