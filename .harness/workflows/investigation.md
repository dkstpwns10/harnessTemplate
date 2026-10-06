# Investigation Workflow (코드 수정 없음)

단계: Research → Evidence → Hypothesis → Verification → Conclusion

- **코드·설정·문서를 수정하지 않는다.** 실험이 필요하면 읽기 전용 명령, 임시 스크립트(`.harness/state/` 아래)만 쓴다. 수정이 필요한 결론이 나오면 Bugfix/Feature/Refactor를 **제안**하고 사용자 승인을 받는다.
- 넓은 탐색은 `researcher` subagent에 맡기고 보고서만 받는다.
- 모든 주장에 Evidence(파일:줄, 로그, 명령 결과)를 붙인다. 확인하지 못한 것은 `Not Verified`로 남긴다.
- 가설은 [bugfix](bugfix.md)의 표 형식을 쓴다.

## 결과 보고

[handoff 형식](../templates/handoff.md) + 아래 두 항목:
- **Conclusion**: 질문에 대한 답 (확정 / 가장 유력 / 판단 불가 중 하나를 명시)
- **Recommended Next Step**: 후속 Workflow와 등급 제안

결론이 장기적으로 유용하면(조사 비용이 컸다면) 사용자에게 기록을 제안한다: 코드 구조에 대한 사실은 `codemap.md`, 결정과 이유는 `docs/decisions.md` ([memory](memory.md)).
