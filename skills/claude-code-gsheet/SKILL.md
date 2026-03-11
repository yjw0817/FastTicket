# Google Sheets 연동

이 프로젝트는 `tools/gsheet.py`를 통해 Google Sheets를 읽고, 쓰고, 관리할 수 있다.

## 언제 사용하는가

사용자가 다음을 요청할 때 `tools/gsheet.py`를 사용한다:
- Google Sheets 데이터 읽기/쓰기/수정
- 셀 값 업데이트 (드롭다운 포함)
- 행 추가, 복사, 삽입
- 셀 검색, 정렬, 서식 변경
- 조건부 서식 적용
- 스프레드시트 생성/관리

## 선행 조건

처음 사용 전 1회 설정 필요:
```bash
pip install google-auth google-auth-oauthlib google-api-python-client
python tools/gsheet.py auth --credentials <path/to/credentials.json>
```

## 커맨드 레퍼런스

```bash
# 기본 CRUD
python tools/gsheet.py read   --id <ID> [--range 'Sheet1!A1:D10']
python tools/gsheet.py write  --id <ID> --range 'Sheet1!B5' --values '[["값"]]'
python tools/gsheet.py append --id <ID> --sheet Sheet1 --values '[["col1","col2"]]'
python tools/gsheet.py clear  --id <ID> --range 'Sheet1!A1:Z100'

# 행 복사 & 삽입
python tools/gsheet.py copy-row --id <ID> --source-row 3 --target-row 7 --sheet Sheet1

# 검색
python tools/gsheet.py search --id <ID> --query '검색어' [--exact] [--sheet Sheet1]

# 정렬
python tools/gsheet.py sort --id <ID> --range 'Sheet1!A2:F100' --column B --order desc

# 행/열 크기
python tools/gsheet.py resize --id <ID> --type col --index B --size 250
python tools/gsheet.py resize --id <ID> --type row --index 1 --size 50

# 서식
python tools/gsheet.py format --id <ID> --range 'Sheet1!A1:D1' --bold true --bg '#4285F4' --fg '#FFFFFF'

# 조건부 서식
python tools/gsheet.py cond-format --id <ID> --range 'Sheet1!C2:C100' --condition number_gt --values 90 --bg '#00FF00'

# 스프레드시트 관리
python tools/gsheet.py info      --id <ID>
python tools/gsheet.py create    --title '새 시트'
python tools/gsheet.py add-sheet --id <ID> --title '새 탭'
```

## 중요 규칙

- `--id`는 스프레드시트 URL 전체 또는 ID만 둘 다 가능
- `--values`는 반드시 JSON 2D 배열: `'[["값1","값2"],["값3","값4"]]'`
- 단일 셀 업데이트: `--values '[["값"]]'`
- 드롭다운 셀도 `write`로 값을 직접 쓰면 된다
- 정렬 시 헤더 제외하려면 range를 A2부터 시작
- 조건부 서식 condition 종류: text_contains, text_eq, number_gt, number_lt, number_eq, number_between, blank, not_blank, custom_formula
- `number_between`은 values 2개: `--values 10 90`
- 출력은 항상 JSON
