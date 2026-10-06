# 장기기억: 무엇을 어디에 남기는가

세션은 매번 빈 context로 시작한다. 다음 세션에 필요한 것은 **파일로 남긴 것뿐**이다. 대화 로그를 보존하지 않는다 — 재개와 재탐색 방지에 필요한 최소한만 남긴다.

| 저장소 | 담는 것 | 수명 | 쓰는 때 | 공유 |
|---|---|---|---|---|
| `.harness/state/current.md` | 진행 중인 **작업 하나**의 상태 (등급, 계획, 한 일, 다음 행동) | 작업이 끝나면 지운다 | 단계가 바뀔 때, 멈출 때, 턴을 끝내기 전(다단계 작업) | 개인 (git 제외) |
| `.harness/project/codemap.md` | **코드 구조에 대한 오래 유효한 사실** (모듈 책임, 진입점, 재사용할 abstraction, 확인된 함정) | 코드가 바뀔 때까지 | 조사·구현에서 새 사실을 확인했을 때 (사용자 승인 후) | 커밋 |
| `docs/prd/<slug>.md` | 요구사항, AC, 변경 이력 | 기능 수명 | requirements workflow | 커밋 |
| `docs/decisions.md` | 결정과 이유 한 줄 (왜 이렇게 했는가) | 영구 | 결정이 내려졌을 때 | 커밋 |
| `.harness/project/project.md` | 프로젝트 식별, 기술, 코드만 봐서는 모르는 규칙 | 영구 | harness-init, 규칙이 생겼을 때 | 커밋 |
| `.harness/project/baseline.md` | 도입 전부터 실패하던 검증 | 해소될 때까지 | 사용자 승인 후 | 커밋 |
| `docs/improvements.md` | 하네스 자체의 개선 후보 | 처리될 때까지 | 반복 문제를 봤을 때 | 커밋 |
| CLI 자체 메모리 (Claude Code auto memory 등) | **개인** 작업 습관·선호 | CLI가 관리 | CLI가 알아서 | 개인 |

## 규칙

1. **프로젝트 사실은 저장소 파일에 둔다.** CLI의 자체 메모리는 사용자·기기마다 달라 공유되지 않고 다른 CLI가 읽지 못한다. 코드 구조, 결정, 함정을 거기에만 두지 않는다.
2. **근거를 함께 적는다.** codemap과 current.md의 사실에는 파일 경로를 backtick으로 적는다 (예: `src/auth/TokenService.kt`). `.harness/memory-check`가 그 경로가 아직 있는지, 그리고 codemap이 가리키는 파일의 **내용이 마지막 확인 이후 바뀌었는지** 검사한다.
3. **기억은 힌트지 사실이 아니다.** 기록을 근거로 코드를 고치기 전에 해당 파일을 실제로 읽어 확인한다. 기록과 코드가 다르면 코드가 맞다 — 기록을 고치자고 제안한다.
4. **codemap에 넣지 않는 것**: 코드를 열면 바로 보이는 것, 일반 기술 지식, 작업 진행 상황, 추측. 한 번의 조사 비용이 컸고 다음에도 필요할 사실만 넣는다. 최대 150줄.
5. **AI는 codemap·decisions·baseline 변경을 제안하고, 사용자 승인 후 기록한다.** current.md는 승인 없이 갱신한다.
6. **확인 도장 (`--stamp`)**: codemap 항목을 실제 코드와 대조해 맞다고 확인했거나 고친 뒤, 사용자 승인을 받아 `.harness/memory-check --stamp`를 실행한다. 그 시점의 내용 지문이 `.harness/project/codemap.lock`에 기록되고(커밋 대상) `Last verified`가 갱신된다. 이후 그 파일이 바뀌면 `MEMORY WARN: … changed since codemap was last verified`가 뜬다. **대조하지 않고 경고를 없애려고 stamp를 찍지 않는다.**
7. **작업을 마칠 때 (task-done)**: current.md에서 오래 유효한 사실을 골라 codemap/decisions 갱신을 제안하고, current.md는 지운다.

## 세션 시작 시

- SessionStart hook(`.harness/hooks/session-start.sh`)이 진행 중 작업 요약과 `MEMORY WARN`을 context에 넣는다. hook이 없는 CLI에서는 `.harness/state/current.md`가 있는지 직접 확인한다.
- 코드를 조사하거나 수정하기 전에 `codemap.md`를 읽는다 (LIGHT 등급의 한 파일 수정은 생략 가능).
- `MEMORY WARN`이 있으면 해당 기록을 믿지 말고, 작업 전에 사용자에게 알린다. "changed since" 경고는 그 파일을 언급하는 codemap 항목만 다시 대조하면 된다 — 맞으면 stamp, 틀리면 수정안을 제안한다.
