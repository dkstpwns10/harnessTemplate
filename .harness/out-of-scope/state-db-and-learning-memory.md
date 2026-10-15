# State DB, 벡터 기억, 자가 학습

**왜 넣지 않는가**: 기억이 DB나 임베딩 안에 있으면 사람이 읽고 고칠 수 없고, git으로 공유·리뷰되지 않으며, 틀린 기억을 찾아 지우기 어렵다. 대화 전체를 보관하는 방식은 낡은 결론을 되살린다.

**대신**: 사람이 읽는 파일 — `current.md`(작업 하나), `codemap.md`(+ `memory-check`의 내용 지문으로 낡음 감지), PRD·티켓·decisions·glossary. 압축 직후에는 SessionStart hook이 `current.md`를 다시 넣는다.

**다시 검토할 조건**: codemap이 150줄로는 부족하고, 파일 검색으로 필요한 기억을 찾지 못하는 실패가 반복될 때.

**이전 제안**: 2026-10-16, ruvnet/ruflo 비교 (AgentDB, HNSW, transcript archive, trajectory learning).
