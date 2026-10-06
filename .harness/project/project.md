# Project Info (프로젝트 소유 — `/harness-init`으로 채운다)

## 식별
- Name: <TODO>
- 한 줄 설명: <TODO>
- 유형: <app | library | service | android | script | docs | infra>

## 기술
- 언어/프레임워크: <예: Kotlin, Spring Boot>
- 모듈 구조: <단일 | 멀티 모듈 | monorepo — 경로 나열>

## 검증
- 진입점: `.harness/verify quick|full [scope]` (설정: [verify.conf](verify.conf))
- 알려진 baseline 실패: [baseline.md](baseline.md)

## 활성 Skill
- 사용: coding, testing, reviewing, git-rules
- 미사용(삭제 후보): kotlin — 쓰지 않는 skill은 `.harness/sync --remove <name>`으로 지운다
- 프로젝트 전용 Skill: (없음) — 추가하면 `.harness/project/skills/<name>/SKILL.md`(frontmatter: `name`, `description`)를 만들고 `.harness/sync`를 실행한다.

## 프로젝트 고유 규칙 (AI가 코드만 봐서는 알 수 없는 것만)
- <예: 도메인 용어, 금지된 라이브러리, 운영 DB 접근 규칙, 배포 제약>

## 보호 대상 (운영 환경)
- <예: prod DB 호스트명, 운영 클라우드 프로필. guard-bash.sh의 PROD_PATTERN에도 추가>
