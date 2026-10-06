---
name: harness-init
description: 하네스를 이 저장소에 맞게 초기화한다 (프로젝트 정보, 검증 명령, baseline, skill 동기화). 템플릿 적용 직후나 기존 프로젝트에 하네스를 도입할 때 한 번 사용.
---

하네스를 이 저장소에 맞게 설정한다. 기존 코드는 바꾸지 않는다.

1. **조사**: 파일 구조, 빌드 도구, 테스트/CI 설정, 기존 문서(README, CLAUDE.md, AGENTS.md), git 상태, 모듈 구조를 확인한다. 빈 저장소인지 기존 프로젝트인지 판단해 알린다.
2. **project.md** (`.harness/project/project.md`) 채우기: 식별, 기술, 모듈, 활성 Skill, 프로젝트 고유 규칙 — 확실한 것만 채우고 모르는 것은 사용자에게 묻는다.
3. **verify.conf**: 프로젝트의 build/test/lint 명령을 찾아 `QUICK_CMD`/`FULL_CMD` 제안 → 사용자 확인 후 기록 → `.harness/verify quick`과 `full`을 실제 실행해 결과를 보여준다.
4. **baseline**: 이미 실패하는 검증이 있으면 `baseline.md`에 기록할 목록을 제안한다 (사용자 승인 후).
5. **codemap**: 조사한 구조를 바탕으로 `.harness/project/codemap.md` 초안(모듈, 진입점, 재사용할 abstraction)을 제안하고 승인 후 기록한다. 확인한 사실만 쓰고, 기록 후 `.harness/memory-check --stamp`를 실행한다. 빈 저장소면 건너뛴다.
6. **충돌 확인**: 기존 CLAUDE.md/AGENTS.md/.claude/.codex/가 이 하네스와 겹치면 덮어쓰지 말고 병합 방안을 제안한다. 기존 `CLAUDE.md`에 `@AGENTS.md` import가 없으면 Claude Code가 하네스 규칙을 읽지 않으므로, 사용자가 그 한 줄을 직접 추가해야 한다는 것을 보고 맨 위에 적는다 (하네스 파일은 AI가 고칠 수 없다).
7. **Skill**: 쓰지 않는 기술 skill(예: kotlin)은 제거를, 필요한 기술 skill은 추가를 제안한다. 제거는 승인 후 `.harness/sync --remove <name>`으로 한다 (`rm`이나 `git rm`으로 직접 지우지 않는다). 추가·수정 후에는 `.harness/sync`.
8. 완료 보고: 설정된 것 / 아직 NOT_CONFIGURED인 것 / 사용자가 해야 할 것(Codex 사용 시 `/hooks`에서 hook 신뢰 승인 포함).
