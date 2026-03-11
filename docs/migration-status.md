# FastTicket 마이그레이션 현황

## 프로젝트 개요
- **구 프로젝트**: `D:\eGovFrameDev-3.10.0-64bit\workspace\FastTicket` (eGovFrame 3.10.0)
- **신 프로젝트**: `D:\Projects\FastTicket\eGovFrameDev-4.3.1-64bit\workspace-egov\FastTicket` (eGovFrame 4.3.1)
- **프레임워크**: Spring 5.3.37, MyBatis 3.5.16, eGovFrame 4.3.0
- **DB**: MSSQL (SQL Server Express) — HSQLDB에서 전환 완료

---

## 완료된 작업

### 1. eGovFrame 3.10.0 → 4.3.1 마이그레이션
- 패키지명 변경: `egovframework.rte` → `org.egovframe.rte`
- pom.xml 의존성 업데이트

### 2. 엔티티 모듈 추가 (기존 Sample만 있었음)
총 9개 모듈 구성 완료:
- **Sample** (기존)
- **Member** (회원)
- **Venue** (공연장)
- **Seat** (좌석)
- **Program** (프로그램/공연)
- **TicketPrice** (티켓가격)
- **Schedule** (공연일정)
- **Booking** (예매)
- **BookingDetail** (예매상세)

각 모듈별 구성 파일:
- Controller, Service(Interface), ServiceImpl, VO, Mapper(Interface)
- SQL Mapper XML (`*_SQL.xml`)

### 3. Spring 설정 파일 수정

#### `context-mapper.xml`
- `MapperConfigurer`의 `basePackage`를 `com.ftk`로 변경 (재귀 스캔)

#### `context-idgen.xml`
- 9개 엔티티별 ID 생성기(EgovTableIdGnrServiceImpl + EgovSequceStrategyImpl) 추가
- ID 패턴: MEMBER-00001, VENUE-00001, SEAT-00001, PROG-00001, TPRC-00001, SCHD-00001, BOOK-00001, BDTL-00001

#### `sql-mapper-config.xml`
- 모든 VO에 대한 typeAlias 등록 완료

### 4. MSSQL 데이터베이스 전환

#### `pom.xml` 의존성 추가
```xml
<!-- MSSQL JDBC Driver -->
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <version>12.4.2.jre8</version>
</dependency>
<!-- Connection Pool -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-dbcp2</artifactId>
    <version>2.9.0</version>
</dependency>
```

#### `context-datasource.xml` 변경
```xml
<!-- HSQLDB embedded → MSSQL -->
<bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="com.microsoft.sqlserver.jdbc.SQLServerDriver"/>
    <property name="url" value="jdbc:sqlserver://localhost\SQLEXPRESS;databaseName=FastTicket;encrypt=true;trustServerCertificate=true"/>
    <property name="username" value="sa"/>
    <property name="password" value="1qazxsw2"/>
</bean>
```

#### SQL 매퍼 XML 변환 (9개 파일 전부)
| 변환 대상 | HSQLDB/MySQL | MSSQL |
|-----------|-------------|-------|
| 페이징 | `LIMIT ? OFFSET ?` | `OFFSET ? ROWS FETCH NEXT ? ROWS ONLY` |
| 현재시각 | `NOW()` | `GETDATE()` |
| 날짜포맷 | `CAST(col AS VARCHAR)` | `CONVERT(VARCHAR, col, 23/120)` |
| 문자열결합 | `CONCAT()` | `CONCAT()` (그대로) |

변환된 파일 목록:
- `EgovSample_Sample_SQL.xml` — 페이징
- `Member_SQL.xml` — 페이징 + GETDATE
- `Venue_SQL.xml` — 페이징 + GETDATE
- `Seat_SQL.xml` — 페이징
- `Program_SQL.xml` — 페이징 + GETDATE + CONVERT
- `TicketPrice_SQL.xml` — 페이징
- `Schedule_SQL.xml` — 페이징 + GETDATE
- `Booking_SQL.xml` — 페이징 + GETDATE
- `BookingDetail_SQL.xml` — 변환 불필요 (페이징/NOW 미사용)

#### MSSQL DDL 스크립트 생성
- 파일: `src/main/resources/db/mssql-schema.sql`
- 10개 테이블 CREATE + IDS 초기 데이터 INSERT
- SSMS에서 FastTicket 데이터베이스에 실행 필요

### 5. MSSQL 서버 설정 (로컬)
- SQL Server Browser 서비스: 시작 유형 `자동` → 시작
- SQLEXPRESS TCP/IP 프로토콜: 활성화
- SQL Server 재시작 후 연결 확인 완료

---

## MSSQL 연결 정보
| 항목 | 값 |
|------|-----|
| 서버 | `localhost\SQLEXPRESS` |
| 데이터베이스 | `FastTicket` |
| 사용자 | `sa` |
| 비밀번호 | `1qazxsw2` |
| 드라이버 | `com.microsoft.sqlserver.jdbc.SQLServerDriver` |
| encrypt | `true` |
| trustServerCertificate | `true` |

---

## 해결한 에러들

### bookingMapper bean not found
- **원인**: context-idgen.xml에 ID 생성기 누락, context-mapper.xml basePackage 범위 부족, sampledb.sql에 테이블 DDL 누락
- **해결**: ID 생성기 8개 추가, basePackage를 `com.ftk`로 확장, 테이블 DDL 추가

### DATE_FORMAT not found (HSQLDB)
- **원인**: HSQLDB는 MySQL의 DATE_FORMAT() 미지원
- **해결**: `CAST(col AS VARCHAR)` 로 변경 → 이후 MSSQL 전환 시 `CONVERT()` 로 재변경

### TCP/IP 연결 실패
- **원인**: SQLEXPRESS의 TCP/IP 프로토콜 비활성화, SQL Server Browser 서비스 중지
- **해결**: TCP/IP 활성화 + Browser 서비스 시작

---

## 남은 작업 / 확인 필요

1. **MSSQL 테이블 생성** — `mssql-schema.sql`을 SSMS에서 실행했는지 확인
2. **데이터 입력** — 테이블 생성 후 테스트 데이터 INSERT
3. **전체 페이지 동작 확인** — 9개 모듈 List/Register 페이지 정상 작동 테스트
4. **Bootstrap 5 적용** — 구 프로젝트(3.10.0)에서 진행 중이던 작업, 신 프로젝트에도 적용 필요
5. **커밋** — 현재 변경사항 Git 커밋

---

## 프로젝트 구조 (주요 파일)

```
src/main/
├── java/com/ftk/
│   ├── sample/    (Controller, Service, ServiceImpl, VO, Mapper)
│   ├── member/
│   ├── venue/
│   ├── seat/
│   ├── program/
│   ├── price/     (TicketPrice)
│   ├── schedule/
│   ├── booking/   (Booking + BookingDetail)
│   └── cmmn/      (공통: DefaultVO, ExceptionHandler 등)
├── resources/
│   ├── egovframework/
│   │   ├── spring/
│   │   │   ├── context-datasource.xml  ← MSSQL 설정
│   │   │   ├── context-mapper.xml
│   │   │   ├── context-idgen.xml       ← 9개 ID 생성기
│   │   │   └── ...
│   │   └── sqlmap/example/
│   │       ├── sql-mapper-config.xml   ← typeAlias
│   │       └── mappers/
│   │           ├── EgovSample_Sample_SQL.xml
│   │           ├── Member_SQL.xml
│   │           ├── Venue_SQL.xml
│   │           ├── Seat_SQL.xml
│   │           ├── Program_SQL.xml
│   │           ├── TicketPrice_SQL.xml
│   │           ├── Schedule_SQL.xml
│   │           ├── Booking_SQL.xml
│   │           └── BookingDetail_SQL.xml
│   └── db/
│       ├── sampledb.sql               ← HSQLDB용 (현재 미사용)
│       └── mssql-schema.sql           ← MSSQL DDL
└── webapp/
    └── WEB-INF/jsp/ftk/
        ├── sample/   (List.jsp, Register.jsp)
        ├── member/
        ├── venue/
        ├── seat/
        ├── program/
        ├── price/
        ├── schedule/
        └── booking/
```

---

*최종 업데이트: 2026-03-05*
