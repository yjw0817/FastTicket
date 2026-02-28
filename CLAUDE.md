# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FastTicket is a Java web application built on **eGovFrame 3.10.0** (Korean government standard framework), using Spring MVC 4.3.25, iBATIS/MyBatis for data access, and JSP views. It packages as a WAR deployed to Tomcat 7.

## Build & Run Commands

```bash
# Build (produces WAR in target/)
mvn install

# Run with embedded Tomcat on port 80
mvn tomcat7:run

# Run tests (tests are skipped by default; override with -DskipTests=false)
mvn test -DskipTests=false

# Run a single test
mvn test -DskipTests=false -Dtest=ClassName

# Generate JavaDoc
mvn javadoc:javadoc

# PMD static analysis
mvn pmd:pmd
```

## Architecture

### 3-Tier MVC (Controller → Service → DAO)

All application code lives under `src/main/java/egovframework/example/`:

- **`sample/web/`** — Spring MVC controllers. All URL mappings use `*.do` suffix (e.g., `/egovSampleList.do`). Controller methods receive `@ModelAttribute` VOs and return JSP view names.
- **`sample/service/`** — Service interfaces and VO classes. `SampleDefaultVO` carries pagination params; `SampleVO` extends it with domain fields (id, name, description, useYn, regUser).
- **`sample/service/impl/`** — Service implementations (`@Service`) and data access. `SampleDAO` uses iBATIS (`EgovAbstractDAO`); `SampleMapper` is the MyBatis alternative. The service impl currently uses `SampleDAO`.
- **`cmmn/`** — Common cross-cutting: exception handlers, custom `WebBindingInitializer`, pagination renderer.

### Spring Configuration (XML-based)

All Spring context files are in `src/main/resources/egovframework/spring/context-*.xml`:

| File | Purpose |
|------|---------|
| `context-datasource.xml` | DataSource — embedded HSQLDB by default; commented configs for MySQL/Oracle |
| `context-mapper.xml` | MyBatis SqlSessionFactory and mapper scanner |
| `context-sqlMap.xml` | iBATIS SqlMapClient (the currently active persistence approach) |
| `context-transaction.xml` | TX manager with AOP advice on `*Service` beans |
| `context-common.xml` | Component scan for `@Service`/`@Repository`, message source, exception handling |
| `context-idgen.xml` | `EgovIdGnrService` — generates `SAMPLE-XXXXX` format IDs |
| `context-properties.xml` | `EgovPropertyService` — pagination settings (pageUnit=10, pageSize=10) |

MVC config is separate: `src/main/webapp/WEB-INF/config/egovframework/springmvc/dispatcher-servlet.xml` — scans for `@Controller`, sets up view resolver (prefix: `/WEB-INF/jsp/egovframework/example/`, suffix: `.jsp`), locale interceptor, pagination manager, and exception mappings.

### Request Pipeline

```
*.do request → CharacterEncodingFilter (UTF-8) → HTMLTagFilter (XSS)
  → DispatcherServlet → @Controller → @Service → DAO/Mapper → HSQLDB
  → JSP view (under WEB-INF/jsp/egovframework/example/)
```

### SQL Mappings

- **iBATIS** (active): `src/main/resources/egovframework/sqlmap/example/sample/EgovSample_Sample_SQL.xml`
- **MyBatis** (alternative): `src/main/resources/egovframework/sqlmap/example/mappers/` + `sql-mapper-config.xml`

### Database

Default is embedded HSQLDB initialized from `src/main/resources/db/sampledb.sql` (SAMPLE table with 114 pre-loaded records). To switch to MySQL or Oracle, uncomment the appropriate dataSource bean in `context-datasource.xml` and corresponding dependencies in `pom.xml`.

### Views

JSP pages in `src/main/webapp/WEB-INF/jsp/egovframework/example/sample/`:
- `egovSampleList.jsp` — paginated list with search
- `egovSampleRegister.jsp` — create/edit form (shared for both)

Static assets: `src/main/webapp/css/`, `images/`, `js/`

## Key Conventions

- **URL pattern**: All controller mappings end with `.do`
- **ID generation**: Auto-generated via `EgovIdGnrService` (format: `SAMPLE-00001`)
- **Validation**: Server-side via `DefaultBeanValidator` + `validator.xml` rules
- **Encoding**: UTF-8 throughout (compiler, filter, message bundles)
- **Language**: Java 8, Korean comments in source code
- **Persistence**: iBATIS is the active DAO layer; MyBatis mapper is configured but the service impl uses `SampleDAO` (iBATIS)
