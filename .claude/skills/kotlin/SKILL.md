---
name: kotlin
description: Kotlin 코드의 프로젝트 convention과 알려진 함정 (Spring/JPA 포함). Kotlin 파일(.kt, .kts)을 작성·수정·리뷰할 때 사용.
---



> 예시이자 시작점. 모델이 이미 아는 Kotlin 기초는 쓰지 않는다. **프로젝트에서 실제로 겪은 함정과 규칙을 발견할 때마다 여기에 추가**한다 (docs/improvements.md → 승인 후).
> 새 기술 Skill(Spring, Android, Python…)은 이 파일을 복사해 같은 형식으로 만든다. 권장 40줄, 최대 80줄.

## 프로젝트 규칙 (채워 넣기)
- 코드 스타일/포맷: <ktlint | detekt | spotless — 설정 위치>
- nullability: `!!` 사용 금지 여부: <TODO>
- 예외 vs Result 사용 기준: <TODO>
- 코루틴 dispatcher 주입 규칙: <TODO>

## 알려진 함정 (검증된 것만)
- `data class`를 JPA Entity로 쓰면 equals/hashCode·lazy proxy 문제가 생긴다 (Spring/JPA 사용 시).
- Spring + Kotlin: `kotlin-spring`(all-open) / `kotlin-jpa`(no-arg) 플러그인 없이는 `final` 클래스 때문에 프록시·AOP가 동작하지 않는다.
- `@Transactional`은 같은 클래스 내부 호출(self-invocation)에서 적용되지 않는다.
- 테스트에서 `runBlocking` 대신 프로젝트가 정한 코루틴 테스트 방식을 쓴다: <TODO>

## 검증
- Gradle: lint/static analysis(detekt, ktlint)가 `FULL_CMD`(`./gradlew build`)에 포함되어 있는지 `verify.conf`에서 확인한다.
