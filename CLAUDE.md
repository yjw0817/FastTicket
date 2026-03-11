# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FastTicket is a ticket booking management system built on the Korean e-Government Standard Framework (eGov Framework 4.3.0) with Spring 5.3.37 and MyBatis. It is a traditional WAR-based web application (not Spring Boot) deployed on a Servlet container.

**Domain modules:** Sample (reference CRUD), Venue, Program, Schedule, TicketPrice, TicketType, SessionPrice, ProductPrice, Seat, Booking, Member, Holiday, BusinessHours, Discount, OnlineBooking

**Local dev server:** `http://localhost:8081/FastTicket/` (port **8081**, context path `/FastTicket`)

**Log directory:** `D:\logs\fastticket\` — `app.log` (일반), `error.log` (에러), `api-param.log` (API 파라미터), `sql.log` (SQL)

**playwright-cli 테스트는 반드시 headed 모드로 실행:** `playwright-cli open --browser=chrome` (headless 금지)

## Build & Run

```bash
# Build WAR
mvn clean install

# Build without tests
mvn clean install -DskipTests

# Run tests (JUnit 5, parallel with 2 threads)
mvn test

# Run a single test class
mvn test -Dtest=ClassName

# Generate PMD report
mvn pmd:pmd
```

**Deployment:** Deploy the WAR to **Tomcat 9.x** (javax.servlet). Tomcat 10+ uses jakarta.servlet and is incompatible with eGov 4.3/Spring 5.

**Local dev server:** `http://localhost:8081/FastTicket/` (port **8081**, context path `/FastTicket`)

## Architecture

```
Controller (*.do URL) → Service (interface) → ServiceImpl → Mapper (@Mapper) → MyBatis XML SQL
```

- **URL pattern:** All requests use `*.do` suffix (e.g., `/egovSampleList.do`)
- **View resolution:** `/WEB-INF/jsp/ftk/{module}/{page}.jsp`
- **ID generation:** Table-based via `EgovIdGnrService` (e.g., `SAMPLE-00001`), not DB auto-increment
- **Pagination:** `CommonDefaultVO` base class with `pageIndex`, `pageUnit`, `pageSize` fields; uses eGov's `<ui:pagination>` tag and `EgovImgPaginationRenderer`

### Key Patterns

Each domain module (`com.ftk.{mod}`) follows the same package/file structure:
- `{mod}/vo/{Entity}VO.java` - Domain object
- `common/vo/CommonDefaultVO.java` - Inherited by all VOs for search/pagination
- `{mod}/service/{Entity}Service.java` - Interface with insert/update/delete/select/selectList/selectListTotCnt
- `{mod}/service/{Entity}ServiceImpl.java` - Implementation extending `EgovAbstractServiceImpl`
- `{mod}/mapper/{Entity}Mapper.java` - MyBatis `@Mapper` interface
- `resources/mapper/{mod}/{Entity}_SQL.xml` - MyBatis SQL mapper
- `{entity}List.jsp` + `{entity}Register.jsp` - List and form views

Controller methods follow PRG (Post-Redirect-Get) pattern.

## Configuration Files

| File | Purpose |
|------|---------|
| `src/main/webapp/WEB-INF/web.xml` | Servlet filters (encoding, HTML tag), DispatcherServlet |
| `src/main/webapp/WEB-INF/config/egovframework/springmvc/dispatcher-servlet.xml` | View resolver, exception mapping, component scanning |
| `src/main/resources/egovframework/spring/context-datasource.xml` | DB connection (HSQLDB default, MySQL/Oracle examples) |
| `src/main/resources/egovframework/spring/context-mapper.xml` | MyBatis SqlSessionFactory, mapper scanning (`mapperLocations = classpath:/mapper/**/*.xml`) |
| `src/main/resources/egovframework/spring/context-idgen.xml` | ID generation service beans |
| `src/main/resources/egovframework/spring/context-properties.xml` | App properties (pageUnit=10, pageSize=10) |
| `src/main/resources/egovframework/sqlmap/example/sql-mapper-config.xml` | MyBatis type aliases (egovMap, searchVO, sampleVO) |

## Database

Default: **HSQLDB** (embedded, in-memory). Schema initialized from `src/main/resources/db/sampledb.sql`.

To switch databases, edit `context-datasource.xml` — commented examples for MySQL/Oracle are included.

MyBatis SQL uses HSQL syntax (`LIMIT ? OFFSET ?`). When switching to MySQL/MariaDB, update pagination queries accordingly.

## Front-End

- **CSS:** Modular architecture in `webapp/css/egovframework/` — `sample.css` is the `@import` hub loading 6 modules (base, sidebar, table, form, components, misc)
- **Bootstrap 5.3.3:** Loaded via CDN in `header.jsp`
- **Fonts:** DM Sans + Noto Sans KR (Google Fonts, loaded in `base.css`)
- **Layout:** Bootstrap 5 Offcanvas sidebar + top bar, defined in `header.jsp`
- **No build tooling** for front-end (no webpack/vite) — CSS files are served directly

## i18n

Message bundles in `src/main/resources/egovframework/message/`:
- `message-common.properties` (base)
- `message-common_ko.properties` (Korean)
- `message-common_en.properties` (English)

Locale switched via `?language=ko` or `?language=en` URL parameter.

## Conventions

- **Language:** Code comments, docs, and UI text are primarily in Korean
- **Package root:** `com.ftk`
- **VO field naming:** MyBatis `EgovMap` returns uppercase column names — JSP EL uses `${result.COLUMN_NAME}`
- **Validation:** Commons Validator via `validator.xml` + `validator-rules.xml`, messages keyed as `title.{entity}.{field}`

## Coding Rules

코드 작성 시 반드시 따라야 할 핵심 규칙. 상세 배경은 `docs/프로젝트 규칙.md` 참조.

### 계층 책임
- **Controller:** 얇게 유지 — 파라미터 검증, Service 호출, 응답 모델 구성만
- **Service:** 비즈니스 로직 중심, 트랜잭션 경계
- **Mapper/DAO:** DB 접근 전담

### DI 규칙
- 생성자 주입 기본 (`@RequiredArgsConstructor`)
- 필드 주입(`@Autowired` 필드) 지양

### 인터페이스 규칙
- Service는 인터페이스(`XxxService`) + 구현체(`XxxServiceImpl`) 구조 유지
- Controller는 구현체가 아닌 인터페이스 타입에 의존

### 트랜잭션
- Service 메서드에 적용, Controller 트랜잭션 지양
- DB 프로시저 자체 COMMIT 시 스프링 트랜잭션과 충돌 방지 — 트랜잭션 주도권을 한쪽으로 명확히

### SQL/MyBatis 전략
- 복잡 SQL → 쿼리 분리, CTE, View 활용
- 실행계획(Explain) + 실 데이터 규모 기준 성능 검증, 근거 없는 "최적화" 주장 금지

### AOP
- 횡단 관심사(로깅/권한/감사)만 적용, 남발 금지
- 적용 대상(Pointcut) 최소화 및 문서화

### 예외 처리
- 비즈니스 예외 / 시스템 예외 구분
- 사용자 메시지 vs 로그 메시지 분리

### 테스트 전략
- Unit: Service/Util 중심
- Integration: Mapper/DB 연동
- 외부 의존성(API, 메일, 파일)은 Mock

### 절대 금지
- Controller에 비즈니스 로직 과다 작성
- 필드 주입(`@Autowired` 필드) 남발
- AOP 남발
- 근거 없는 "최적화" 주장 (테스트/실행계획으로 증명)
