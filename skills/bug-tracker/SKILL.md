# Bug Tracker - Google Sheets 버그 등록

사용자가 "버그 등록해", "시트에 등록해", "버그 트래커에 추가해" 등을 요청할 때 이 스킬을 사용한다.

## 스프레드시트 정보

- **ID**: `1E4qPuNmpo4HxiPX9bNgwhuPKER9TDx4aXaeeKNF2Q4A`
- **시트명**: `Bug_Log`
- **도구 경로**: `.claude/skills/claude-code-gsheet/tools/gsheet.py`
- **실행**: `python -W ignore <도구경로> <command> --id <ID> [options] 2>nul`

## 컬럼 매핑 (A~T)

| 컬럼 | 항목 | 구분 | 비고 |
|------|------|------|------|
| A | ID | 자동 | 수식 - 건드리지 않음 |
| B | 등록일 | **입력** | YYYY-MM-DD 형식 (오늘 날짜) |
| C | 등록자 | 자동 | 수식 - 건드리지 않음 |
| D | 채널 | **선택** | 내부, 고객, 모니터링, QA, 기타 |
| E | 모듈/기능 | **입력** | 메뉴명/하려고한일 (예: 상품관리/종료일변경) |
| F | 제목 | **입력** | 텍스트 |
| G | 상세설명 | **입력** | 무엇을 하려고 할 때 어떤 오류가 있었는지 상세 기술 |
| H | 재현절차 | **입력** | 오류를 재현하는 단계별 절차 (각 단계는 \n으로 줄바꿈: "1. 메뉴 접근\n2. 조건 선택\n3. 버튼 클릭") |
| I | 기대결과 | **입력** | 텍스트 |
| J | 실제결과 | **입력** | 텍스트 |
| K | 심각도 | **선택** | Blocker, Critical, Major, Minor, Trivial |
| L | 우선순위 | **선택** | P0, P1, P2, P3 |
| M | 상태 | **선택** | New, In Progress, Fix Ready, QA, Done, Reopen, Won't Fix |
| N | 담당자 | 자동 | 건드리지 않음 |
| O | 목표일 | **입력** | 수정일 (YYYY-MM-DD) |
| P | 완료일 | **입력** | 수정일 (YYYY-MM-DD) |
| Q | 링크(PR/티켓/로그) | **입력** | 오류 발생 페이지 URL (예: /teventmain/buy_event_manage1) |
| R | 원인분류 | **선택** | 요구사항, 로직, 데이터, 인프라, 권한, 외부연동, 성능, 보안, 기타 |
| S | 비고 | **입력** | 텍스트 |
| T | 경과일 | 자동 | 수식 - 건드리지 않음 |

## 등록 절차 (반드시 이 순서를 따를 것)

### Step 1: 빈 템플릿 행 찾기

A열을 읽어서 ID가 비어있는 **첫 번째 행**을 찾는다. 이 행이 서식이 적용된 템플릿 행이다.

```bash
python -W ignore <도구경로> read --id <ID> --range "Bug_Log!A2:A100" 2>nul
```

ID가 있는 마지막 행의 **다음 행**이 첫 번째 빈 템플릿 행이다.
예: 7행까지 ID가 있으면 → 8행이 첫 번째 빈 템플릿 행

### Step 2: 템플릿 행 복사 (서식 유지)

빈 템플릿 행을 복사하여 다음 행에 붙여넣는다. 이렇게 하면 항상 여분의 템플릿 행이 유지된다.

```bash
python -W ignore <도구경로> copy-row --id <ID> --source-row <빈행번호> --target-row <빈행번호+1> --sheet Bug_Log 2>nul
```

### Step 3: 데이터 입력

찾은 빈 템플릿 행에 **선택/입력 항목만** 기록한다. 자동 컬럼(A,C,N,O,P,T)은 절대 건드리지 않는다.

**한 번에 여러 셀을 쓸 때:**
```bash
# B 컬럼 (등록일) - 오늘 날짜 YYYY-MM-DD 형식
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!B<행>" --values '[["2026-02-05"]]' 2>nul

# D~J 컬럼 (채널 ~ 실제결과)
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!D<행>:J<행>" --values '[["채널","모듈/기능","제목","상세설명","재현절차","기대결과","실제결과"]]' 2>nul

# K~M 컬럼 (심각도 ~ 상태)
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!K<행>:M<행>" --values '[["심각도","우선순위","상태"]]' 2>nul

# O~P 컬럼 (목표일, 완료일) - 수정일 입력
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!O<행>:P<행>" --values '[["2026-02-05","2026-02-05"]]' 2>nul

# Q~S 컬럼 (링크, 원인분류, 비고)
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!Q<행>:S<행>" --values '[["링크","원인분류","비고"]]' 2>nul
```

### Step 4: 등록 확인

등록된 행을 다시 읽어서 확인한다.

```bash
python -W ignore <도구경로> read --id <ID> --range "Bug_Log!A<행>:T<행>" 2>nul
```

## 중요 규칙

1. **자동 컬럼에 절대 쓰지 않는다** (A,C,N,T) - 수식이 깨짐
2. **선택 항목은 반드시 Lists 시트의 값과 정확히 일치**해야 한다 (대소문자 포함)
3. **`--values`는 반드시 JSON 2D 배열**: `'[["값1","값2"]]'`
4. 값에 큰따옴표가 포함되면 이스케이프: `\"` 또는 작은따옴표 사용
5. 개행이 필요하면 `\n` 사용
6. 등록 후 반드시 Step 4로 확인
7. 상태가 지정되지 않으면 기본값 **New** 사용
8. 코드 수정 버그의 경우: 채널=내부, 원인분류=로직, 링크=관련 URL

## 등록 예시

코드 버그 수정 후 등록 요청 시:

```bash
# 1. 빈 행 찾기 (예: 8행)
# 2. 템플릿 복사
python -W ignore <도구경로> copy-row --id <ID> --source-row 8 --target-row 9 --sheet Bug_Log 2>nul

# 3-0. B 컬럼 (등록일) - 오늘 날짜
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!B8" --values '[["2026-02-05"]]' 2>nul

# 3-1. D~J 입력 (재현절차는 \n으로 줄바꿈)
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!D8:J8" --values '[["내부","로그 대시보드","패널 건수와 테이블 불일치","요약 패널은 모든 오류를 카운트하지만 테이블은 미해결만 표시","1. 로그 대시보드 페이지 접근\n2. 상단 패널 건수 확인\n3. 하단 테이블 건수 비교","패널과 테이블 건수 일치","패널 Critical:1 Error:1 표시, 테이블 0건"]]' 2>nul

# 3-2. K~M 입력
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!K8:M8" --values '[["Major","P2","Done"]]' 2>nul

# 3-3. O~P 입력 (목표일, 완료일)
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!O8:P8" --values '[["2026-02-05","2026-02-05"]]' 2>nul

# 3-4. Q~S 입력
python -W ignore <도구경로> write --id <ID> --range "Bug_Log!Q8:S8" --values '[["","로직","show_resolved 파라미터 누락"]]' 2>nul

# 4. 확인
python -W ignore <도구경로> read --id <ID> --range "Bug_Log!A8:T8" 2>nul
```
