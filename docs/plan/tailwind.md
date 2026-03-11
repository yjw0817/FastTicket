# Claude Code 지침: 전자정부프레임워크(JSP) 프로젝트에 Tailwind “CSS 산출물만” 적용

## 목표

* 전자정부프레임워크(JSP 기반) 프로젝트에 Tailwind를 **빌드해서 나온 CSS 파일 1개만** 배포에 포함한다.
* 런타임(서버)에서는 Node/Tailwind가 필요 없고, **개발/CI에서만** Tailwind 빌드를 수행한다.
* 캐시/동적 클래스 누락(safelist) 문제까지 최소 구성으로 해결한다.

---

## 전제

* 프로젝트는 Maven/Gradle 어떤 것이든 상관 없음. (빌드는 별도 스크립트로 수행)
* 정적 리소스는 `src/main/webapp` 하위에서 서빙된다고 가정한다.
  (만약 다른 경로라면, “산출물 저장 경로”만 그에 맞게 조정)

---

## 1) Tailwind 빌드용 폴더/파일 생성

프로젝트 루트에 아래를 만든다.

1. `frontend/` 폴더 생성
2. `frontend/package.json` 생성 (Tailwind CLI 기반)
3. `frontend/tailwind.config.js` 생성
4. `frontend/src/input.css` 생성
5. 빌드 결과물을 전자정부 정적 폴더에 생성:
   `src/main/webapp/assets/css/tailwind.min.css`

### 1-1) `frontend/src/input.css` 내용

* Tailwind 기본 지시문만 포함
* 예시:

  * `@tailwind base;`
  * `@tailwind components;`
  * `@tailwind utilities;`

---

## 2) Content 스캔(중요)

Tailwind가 JSP/태그파일/JS를 스캔하도록 `content` 경로를 정확히 넣는다.

### 기본 content 경로(전자정부/JSP에서 흔함)

* `src/main/webapp/**/*.jsp`
* `src/main/webapp/**/*.tag`
* `src/main/webapp/**/*.html`
* `src/main/webapp/**/*.js`
* `src/main/webapp/**/*.ts` (있으면)

※ 프로젝트가 `egovframework` 템플릿을 쓰면 JSP가 `WEB-INF/jsp/` 하위에 있을 가능성이 높으니:

* `src/main/webapp/WEB-INF/**/*.jsp` 포함

---

## 3) Safelist(동적 클래스 대비)

JSP에서 클래스가 조건문/템플릿으로 조립되면 purge에서 누락될 수 있다.

### 규칙

* 가능하면 동적 조립 금지:
  `class="bg-${color}-500"` 같은 패턴은 피하고, 완성된 클래스를 조건 분기에서 선택한다.
* 불가피하면 `safelist`를 추가한다.

### Safelist 예시(필요 최소)

* 색상/상태용 자주 쓰는 클래스 몇 개를 고정 등록
* 또는 정규식 패턴을 사용(너무 광범위하면 CSS가 커짐)

---

## 4) 빌드 스크립트

Tailwind CLI로 input.css → tailwind.min.css 생성한다.

### 개발용(빠르게 확인)

* watch 모드 지원: 변경 시 자동 빌드

### 배포용(압축)

* `--minify` 옵션 사용
* source map은 정책에 따라 선택(운영에선 보통 off)

---

## 5) 전자정부(JSP)에 CSS 링크 추가

공통 레이아웃(헤더/템플릿)에 아래 1줄을 추가한다.

* `/assets/css/tailwind.min.css` 를 `<link rel="stylesheet" ...>`로 포함

### 캐시 무효화(권장)

브라우저 캐시 때문에 배포 후 반영이 안 되는 일이 많으니 아래 중 하나를 적용:

A안) 쿼리스트링 버전

* `/assets/css/tailwind.min.css?v=YYYYMMDDHHmm`
  (빌드 번호나 커밋 해시로 자동화 가능)

B안) 파일명에 버전/해시

* `tailwind.20260305.min.css` 처럼 이름을 바꾸고 JSP 링크도 같이 변경
  (가장 확실하지만 링크 수정 자동화 필요)

---

## 6) 운영 정책(가장 무난한 방식)

* **Node/Tailwind는 개발/CI에서만 설치**
* 빌드 결과물(`tailwind.min.css`)은

  * (선호1) CI에서 생성 후 아티팩트로 포함하여 배포
  * (선호2) 생성된 파일을 레포에 커밋 (조직 정책에 따라)

---

## 7) 체크리스트(Claude Code가 반드시 검증할 것)

1. `tailwind.min.css`가 실제로 `src/main/webapp/assets/css/`에 생성되는가?
2. JSP에서 링크 경로가 정확한가? (컨텍스트 경로 포함 여부 확인)
3. 화면에서 사용한 Tailwind 클래스가 빌드 결과에 포함되는가?
4. JSP의 동적 클래스 때문에 누락되는 항목이 없는가? (있으면 safelist 추가)
5. 캐시 문제로 변경이 안 보이면 버전 전략(A/B) 적용했는가?

---

## 8) 최종 산출물 요구

Claude Code는 다음을 “실제 파일 생성/수정”까지 완료해야 한다.

* `frontend/package.json`
* `frontend/tailwind.config.js`
* `frontend/src/input.css`
* 빌드 명령(스크립트) 정의
* `src/main/webapp/assets/css/tailwind.min.css` 생성(최소 1회 빌드로 생성 확인)
* 공통 JSP 레이아웃에 `<link ...>` 추가
* (선택) 캐시 무효화 전략 반영

---

## 9) 추가 가이드(실수 방지)

* Tailwind 클래스는 가능한 한 문자열로 “완성형”을 사용한다. (동적 조합 최소화)
* 기존 CSS와 충돌이 있으면,

  * 우선 tailwind 적용 범위를 페이지 단위로 시작하거나
  * legacy CSS의 우선순위를 낮추는 방식으로 점진 도입한다.
