---
name: git-rules
description: 이 프로젝트의 git 규칙 (commit/push 승인, 미커밋 변경 보호, checkpoint, 실패한 시도 복구). commit·branch·되돌리기 관련 작업 전에 사용.
---



git은 선택 기능이다. 저장소가 git이 아니면 이 문서의 복구 방법 대신 변경 파일 목록을 `current.md`에 기록하고 사용자에게 백업/초기화를 제안한다.

## 규칙
- **commit·push는 사용자 승인 후**에만 (permission이 확인을 요구한다). 메시지는 이 프로젝트의 기존 로그 스타일을 따른다.
- 단일 branch 흐름이 기본. branch 생성·merge·rebase는 사용자가 요청할 때만.
- force push, history 재작성(`rebase`, `commit --amend`로 공개된 커밋 수정), `reset --hard`, `clean -f`는 AI가 실행하지 않는다 (Hook이 차단). 필요하면 이유와 명령을 사용자에게 안내.
- **사용자의 미커밋 변경을 건드리지 않는다.** 작업 시작 시 `git status`로 이미 있는 변경을 기록한다 (`current.md`의 `Pre-existing changes`). 내 변경과 섞이면 커밋 범위를 사용자와 정한다.
- `.env`, key, 빌드 산출물을 `git add`하지 않는다. 파일을 하나씩 지정해서 add 한다 (`git add -A` 금지).

## Checkpoint (선택 — 사용자가 켰을 때만)
목적은 history가 아니라 **실패한 시도에서 깨끗하게 돌아오기**다.
- 큰 작업(FULL, Refactor) 시작 전 사용자에게 제안: "현재 상태를 commit/stash 해두면 복구가 쉽다."
- 승인 시: 검증 통과한 단계마다 사용자 승인 하에 WIP commit → 끝나면 사용자가 squash.
- 자동 commit은 하지 않는다.

## 실패한 시도에서 복구
수정 위에 수정을 쌓지 않는다. 시도가 실패하면:
1. 이번 시도에서 **내가 바꾼 파일 목록**을 확인한다 (`git diff --stat`, 사용자 기존 변경과 구분).
2. 그 파일들만 되돌릴 계획을 사용자에게 보여주고 승인받는다 (`git restore <files>` — 사용자가 직접 실행하거나 승인 후 실행).
3. 되돌린 뒤 원인 조사(`.harness/workflows/bugfix.md`)로 돌아간다. 같은 수정을 다시 시도하지 않는다.
