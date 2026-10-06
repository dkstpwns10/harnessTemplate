---
name: testing
description: 검증 실행(.harness/verify)과 테스트 작성·변경 규칙, Verification Integrity 기준. 테스트를 쓰거나 고칠 때, 검증을 실행하거나 실패를 해석할 때 사용.
---



("어떻게 다루는가"만. 순서는 Workflow.)

## Verification 실행
- 항상 `.harness/verify quick [scope]` / `.harness/verify full`로 실행한다. build/test/lint 명령을 직접 호출하지 않는다.
- 결과의 마지막 `VERIFY:` 줄이 사실이다. 종류: `PASS`, `FAIL`, `NOT_CONFIGURED`. **NOT_CONFIGURED는 통과가 아니다** — 사용자에게 설정을 요청하거나 `Not Verified`로 보고한다.
- 로그는 `.harness/state/last-verify.log`. 실패 시 전체 로그 대신 실패한 부분만 인용한다.
- baseline 실패는 `.harness/project/baseline.md`와 대조해서 "새 실패"와 구분해 보고한다.
- 검증할 수 없는 영역(UI, 외부 서비스, 실기기, 테스트 없는 코드)은 `Not Verified`에 명시한다. 검증한 척하지 않는다.

## 테스트 작성
- 요구사항(AC) 하나당 최소 하나의 테스트가 대응되게 한다. 테스트 이름에 동작을 쓴다.
- 구현 세부가 아니라 관찰 가능한 동작을 검증한다. 구현을 그대로 베낀 기대값은 쓰지 않는다.
- 버그 수정은 **먼저 실패하는 테스트**를 확인한 뒤 고친다.

## 테스트 변경 규칙 (Verification Integrity)
테스트 파일을 바꿨다는 사실만으로 문제는 아니다. 변경마다 아래 중 어느 쪽인지 근거를 말할 수 있어야 한다.

| 정당 (근거 필요) | 부적절 |
|---|---|
| 요구사항 변경(PRD Change Log 참조) · 의도된 동작 변경 · 새 edge case · 버그 재현 테스트 · 잘못된 기존 테스트 수정(왜 잘못인지 설명) | 실패를 숨기려는 assertion 완화 · 실패 테스트 삭제/skip · 검증 범위 축소 · 구현의 잘못된 동작에 테스트를 맞춤 |

- 기존 테스트의 **기대값을 바꿀 때**는 `Original → Changed, Reason (요구사항/증거)`를 보고에 남긴다. 이유가 "테스트가 실패해서"뿐이면 부적절이다.
- `.harness/verify full`은 `INTEGRITY` 경고(assertion 감소, skip/disable 추가, 테스트 삭제, 검증 설정 변경)를 출력한다. 경고는 실패가 아니지만 **완료 보고에서 정당성을 설명**해야 한다.
- 검증 설정(CI, 빌드 스크립트의 test/lint 부분, `verify.conf`) 변경도 같은 기준이다.

### 사용자가 테스트 약화를 요청할 때 ("일단 통과만 시켜", "@Ignore 붙여")
1. 요청대로 약화하지도, **말없이 다른 조치로 바꿔 실행하지도 않는다.** 먼저 한두 문장으로 무엇이 실패하는지와 약화했을 때 배포되는 결함을 알리고, 대안(원인 수정 예상 범위)을 제시해 선택을 받는다. 원인이 이미 명백하고 한두 줄 수정이면 그 사실을 말하고 수정안을 보여 준 뒤 진행 여부를 묻는다.
2. 사용자가 그래도 약화를 선택하면 따른다 (결정은 사용자 몫). 이때 skip 사유를 테스트에 주석으로 남기고, `.harness/project/baseline.md`에 추가할 항목을 제안하며, 완료 보고의 `INTEGRITY`에 "사용자 승인 약화"로 적는다.
