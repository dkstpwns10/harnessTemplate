# Handoff / 보고 형식

Agent 간 전달과 사용자 보고의 공통 형식. 해당 없는 섹션은 `없음`으로 쓰고 지우지 않는다. 주관적 신뢰도 수치(`confidence: 0.9`)는 쓰지 않는다 — 대신 `Verified`와 `Not Verified`를 구분한다.

```
## Summary
(결론 1~3문장)

## Findings
(발견 사항. 각 항목에 Evidence 참조)

## Evidence
(파일:줄, 명령과 출력 일부, 로그 인용 — 수신자가 결론을 믿지 않고 직접 확인할 수 있게)

## Verified
(실제로 실행/확인한 것)

## Not Verified
(확인하지 못한 것과 이유)

## Changed Files
(없으면 "없음". 읽기 전용 Role은 항상 없음)

## Risks

## Open Questions

## Next Action
(수신자가 할 일 한 가지)
```

수신자는 전달받은 결론을 **사실로 가정하지 않는다.** 중요한 결론은 Evidence로 재확인한다. 전체 대화 대신 이 문서만 넘긴다.
Role별 추가 섹션은 [roles.md](../roles.md) 참조.
