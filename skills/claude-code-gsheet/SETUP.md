# Google Sheets 연동 설정 가이드

## 1단계: Google Cloud 프로젝트 설정

1. https://console.cloud.google.com 접속
2. 프로젝트 생성 (또는 기존 프로젝트 선택)
3. **APIs & Services → Library** → "Google Sheets API" 검색 → **사용 설정**
4. **APIs & Services → Credentials → Create Credentials → OAuth 2.0 Client ID**
5. Application type: **Desktop app** 선택
6. 생성된 JSON 파일 다운로드 → 프로젝트 루트에 `credentials.json`으로 저장

## 2단계: 패키지 설치

```bash
pip install google-auth google-auth-oauthlib google-api-python-client
```

## 3단계: OAuth 인증 (1회)

```bash
python tools/gsheet.py auth --credentials credentials.json
```

브라우저가 열리고 Google 계정으로 로그인하면 토큰이 `~/.gsheet_token.json`에 저장된다.
이후로는 인증 없이 바로 사용 가능.

## 4단계: 테스트

```bash
# 스프레드시트 정보 확인
python tools/gsheet.py info --id "스프레드시트_URL"

# 데이터 읽기
python tools/gsheet.py read --id "스프레드시트_URL"
```

## 사용법

Claude Code에서 자연어로 요청하면 된다:

- "시트에서 B5 셀을 '완료'로 변경해줘"
- "Sheet1에서 'error' 검색해줘"
- "A열 기준으로 내림차순 정렬해줘"
- "점수가 90 이상인 셀을 초록색으로 표시해줘"

Claude Code가 CLAUDE.md를 읽고 자동으로 gsheet.py를 사용한다.
