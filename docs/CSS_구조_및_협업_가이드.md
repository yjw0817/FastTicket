# FastTicket CSS 구조 및 팀 협업 가이드

## 1. 개요

FastTicket 관리자 페이지의 CSS를 **영역별 모듈 파일**로 분리하여,
팀원 간 동시 작업 시 **Git 충돌(Conflict)을 최소화**하도록 구성하였습니다.

> 기존: `sample.css` 1개 파일 (880줄)에 모든 스타일 집중
> 변경: `sample.css` (import 허브) + 6개 모듈 파일

---

## 2. 파일 구조

```
src/main/webapp/css/egovframework/
├── sample.css         ← import 허브 (JSP에서 참조하는 진입점)
├── base.css           ← 변수, 리셋, 타이포그래피
├── sidebar.css        ← 사이드바, 탑바, 레이아웃
├── table.css          ← 검색바, 테이블, 페이지네이션
├── form.css           ← 버튼, 폼 테이블, 입력 필드
├── components.css     ← 뱃지, Empty State
└── misc.css           ← 기타, 레거시 숨김, 모바일 반응형
```

### sample.css (import 허브)

```css
@import url('base.css');
@import url('sidebar.css');
@import url('table.css');
@import url('form.css');
@import url('components.css');
@import url('misc.css');
```

- 16개 JSP 파일은 기존과 동일하게 `sample.css`만 참조
- **JSP 수정 없이** 모듈 분리가 적용됨

---

## 3. 각 파일 역할

| 파일 | 내용 | 주요 셀렉터 |
|------|------|-------------|
| **base.css** | CSS 변수(`:root`), 리셋, 폰트, 링크 기본 스타일 | `:root`, `body`, `a`, `*` |
| **sidebar.css** | 사이드바 메뉴, 탑바, 데스크탑/모바일 레이아웃 전환 | `#sidebar`, `#topbar`, `.topbar-*`, `@media` 레이아웃 |
| **table.css** | 콘텐츠 영역, 검색바, 테이블 카드, 행 스타일, 페이지네이션 | `#content`, `#search`, `#table`, `th`, `td`, `#paging` |
| **form.css** | 버튼 스타일, 등록/수정 폼 테이블, 입력 필드 (input, select, textarea) | `.btn`, `#sysbtn`, `.tbtd_caption`, `input`, `select` |
| **components.css** | 상태 뱃지, 데이터 없음 안내 (Empty State) | `.badge-*`, `.empty-state` |
| **misc.css** | 예매 상세 테이블, 레거시 요소 숨김, 모바일 반응형 | `.section-title`, `.detail-table`, `#header` 숨김, `@media` 모바일 |

---

## 4. 팀 분업 예시

### 2인 팀

| 담당자 | 수정 파일 | 작업 영역 |
|--------|-----------|-----------|
| A | `sidebar.css`, `base.css` | 네비게이션, 테마 색상 |
| B | `table.css`, `form.css`, `components.css` | 목록/등록 페이지, 컴포넌트 |

### 3~4인 팀

| 담당자 | 수정 파일 | 작업 영역 |
|--------|-----------|-----------|
| A | `sidebar.css` | 사이드바, 탑바 |
| B | `table.css` | 목록 페이지, 검색, 페이지네이션 |
| C | `form.css` | 등록/수정 폼, 버튼 |
| D | `components.css`, `misc.css` | 뱃지, 반응형, 기타 |

> `base.css`는 CSS 변수 정의이므로 **변경이 드물고**, 변경 시 전체 영향을 주므로 **리더가 관리**하는 것을 권장합니다.

---

## 5. Git 협업 워크플로우

### 5-1. 브랜치 전략

```
master (배포용 — 직접 push 금지)
  ├── feature/sidebar-redesign     ← A가 sidebar.css 수정
  ├── feature/table-filter         ← B가 table.css 수정
  └── fix/form-validation          ← C가 form.css 수정
```

### 5-2. 작업 흐름

```bash
# 1) 작업 시작 — 최신 코드 가져오기
git checkout master
git pull origin master
git checkout -b feature/작업명

# 2) 작업 + 커밋
#    (담당 CSS 파일만 수정)
git add src/main/webapp/css/egovframework/table.css
git commit -m "테이블 hover 색상 변경"

# 3) 머지 전 최신화
git pull origin master

# 4) push 후 Pull Request 생성
git push origin feature/작업명
#    → GitHub에서 PR 생성 → 코드 리뷰 → Merge
```

### 5-3. 충돌 방지 원칙

| 원칙 | 설명 |
|------|------|
| **파일 단위 분업** | 같은 CSS 파일을 동시에 수정하지 않음 |
| **짧은 브랜치 수명** | 1~3일 단위로 작업 후 머지 |
| **자주 pull** | 작업 시작 전, 커밋 전 항상 `git pull` |
| **작은 커밋** | 한 커밋에 한 가지 변경만 포함 |
| **PR 코드 리뷰** | master에 직접 push하지 않고 PR로 머지 |

---

## 6. 새 스타일 추가 시 가이드

### 어느 파일에 작성해야 하나?

| 추가할 스타일 | 파일 |
|--------------|------|
| 새 CSS 변수, 색상 추가 | `base.css` |
| 사이드바 메뉴 항목 추가 | `sidebar.css` |
| 새 목록 페이지 테이블 스타일 | `table.css` |
| 새 폼 입력 필드 스타일 | `form.css` |
| 새 상태 뱃지 (예: `.badge-vip`) | `components.css` |
| 새 페이지 전용 스타일 | `misc.css` 또는 새 파일 생성 |

### 새 CSS 파일 추가 방법

1. `css/egovframework/` 아래에 파일 생성 (예: `dashboard.css`)
2. `sample.css`에 import 추가:
   ```css
   @import url('dashboard.css');
   ```
3. JSP 수정 불필요

---

## 7. WTP 배포 (Eclipse 개발 환경)

CSS 파일 수정 후 Eclipse 핫리로드를 위해 WTP 경로에 복사가 필요합니다.

```bash
# 소스 경로
SRC=src/main/webapp/css/egovframework/

# WTP 배포 경로
WTP=D:/eGovFrameDev-3.10.0-64bit/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/FastTicket/css/egovframework/

# 전체 복사
cp $SRC/*.css $WTP/
```

---

## 8. 기술 참고사항

- **CSS @import 방식**: `sample.css`가 6개 파일을 `@import`로 로드
- **로딩 순서**: import 순서대로 적용되므로 `base.css`가 가장 먼저 로드됨
- **브라우저 호환**: 모든 모던 브라우저에서 `@import` 지원
- **Bootstrap 5.3.3**: CDN으로 로드되며, 커스텀 CSS가 이후에 로드되어 오버라이드
- **성능**: 관리자 페이지(내부 시스템)이므로 @import의 순차 로딩이 문제되지 않음. 향후 번들링 도구(Webpack 등) 도입 시 하나로 합칠 수 있음
