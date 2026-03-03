# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FastTicket is a Korean eGovernment Framework (eGovFrame 3.10.0) web application built on Spring MVC 4.3.25. It currently contains the eGovFrame sample CRUD application for managing "Sample" entities with HSQLDB as the embedded database.

## Build & Run Commands

```bash
# Build the WAR (tests are skipped by default in pom.xml)
mvn clean package

# Run with embedded Tomcat on port 80
mvn tomcat7:run

# Run tests (currently no test files exist, but the framework is set up)
mvn test -DskipTests=false
```

The application is accessed at `http://localhost/` and all request URLs use the `*.do` pattern (e.g., `/egovSampleList.do`).

## Architecture

### Three-Tier Layered Structure

```
Controller (web) → Service (service) → DAO/Mapper (persistence) → MyBatis SQL XML
```

All source code lives under the `egovframework.example` package:

- **`cmmn/`** — Common infrastructure: exception handlers, binding initializer, pagination renderer
- **`sample/web/`** — Spring MVC controllers (`*Controller.java`)
- **`sample/service/`** — Service interfaces and VOs (value objects)
- **`sample/service/impl/`** — Service implementations, DAO classes, MyBatis mapper interfaces

### Spring Configuration (XML-based)

Application context is split across multiple XML files in `src/main/resources/egovframework/spring/`:

| File | Purpose |
|------|---------|
| `context-datasource.xml` | HSQLDB embedded datasource |
| `context-mapper.xml` | MyBatis SqlSessionFactory and mapper scanning |
| `context-transaction.xml` | Transaction management |
| `context-idgen.xml` | ID generation (UUID strategy) |
| `context-common.xml` | Message source, trace/exception handling |
| `context-aspect.xml` | AOP configuration |
| `context-properties.xml` | Pagination properties (pageUnit=10, pageSize=10) |
| `context-validator.xml` | Bean validation |

The MVC dispatcher servlet config is at `src/main/webapp/WEB-INF/config/egovframework/springmvc/dispatcher-servlet.xml`.

### Data Access

- **ORM**: MyBatis with XML-based SQL mapping files in `src/main/resources/egovframework/sqlmap/example/`
- **Database**: HSQLDB (embedded). MySQL and Oracle configs exist commented out in `pom.xml` and `context-datasource.xml`
- **Schema**: Defined in `src/main/resources/db/sampledb.sql` — `SAMPLE` table (ID, NAME, DESCRIPTION, USE_YN, REG_USER) and `IDS` table for sequence generation

### View Layer

- JSP pages located at `src/main/webapp/WEB-INF/jsp/egovframework/example/sample/`
- View resolver prefix: `/WEB-INF/jsp/` with `.jsp` suffix
- CSS at `src/main/webapp/css/egovframework/sample.css`
- i18n message bundles at `src/main/resources/egovframework/message/` (Korean and English)

## Key Conventions

- **Java version**: 1.8 (source and target)
- **Encoding**: UTF-8 throughout (source files, web filter, JSP pages)
- **Naming**: eGovFrame conventions — classes prefixed with `Egov`, SQL mapper XML files named `EgovSample_*_SQL.xml`
- **URL pattern**: All requests routed through `*.do` (configured in `web.xml`)
- **Component scanning**: `egovframework` package is scanned for `@Controller`, `@Service`, `@Repository`
- **IDE**: Eclipse with Spring IDE tools (`.project`, `.classpath`, `.settings/` present)
