# GAP 분석 구현 완료 보고서

> 작성일: 2026-03-10
> 기준 문서: `docs/plan/GAP분석_회의vs현재개발.md` (2026.03.01 회의 기반)

---

## 구현 요약

2026.03.01 회의에서 도출된 10개 GAP 항목을 5개 Phase로 나누어 순차 구현 완료.

| Phase | 내용 | 상태 |
|-------|------|------|
| Phase 1 | 기초 설정 & 데이터 모델 변경 | ✅ 완료 |
| Phase 2 | 회차 입장권 핵심 UI | ✅ 완료 |
| Phase 3 | 상품 유형 분리 | ✅ 완료 |
| Phase 4 | 부가 기능 (휴무일/영업시간/할인) | ✅ 완료 |
| Phase 5 | 온라인 예약 연동 | ✅ 완료 |

---

## Phase 1: 기초 설정 & 데이터 모델 변경

### 1-1. 권종(Ticket Type) 관리 — GAP #6 해소

업체별 커스텀 권종을 자유롭게 등록/수정/삭제할 수 있는 기초 설정 모듈.

**DB 테이블:** `TICKET_TYPE`
| 컬럼 | 설명 |
|------|------|
| TICKET_TYPE_ID | PK (TTYP-00001) |
| TYPE_NM | 권종명 (어린이, 청소년, 성인, 경로 등) |
| SORT_ORDER | 정렬순서 |
| USE_YN | 사용여부 |
| REG_DT | 등록일 |

**파일 구조:**
```
com/ftk/tickettype/
├── vo/TicketTypeVO.java
├── mapper/TicketTypeMapper.java
├── service/TicketTypeService.java
├── service/TicketTypeServiceImpl.java
└── controller/TicketTypeController.java

resources/mapper/tickettype/TicketType_SQL.xml
WEB-INF/jsp/ftk/tickettype/ticketTypeList.jsp
```

**주요 URL:**
- `/ticketTypeList.do` — 권종 목록 (Bootstrap 모달 CRUD)
- `/insertTicketType.do` — 등록 (AJAX)
- `/updateTicketType.do` — 수정 (AJAX)
- `/deleteTicketType.do` — 삭제 (AJAX)

**ID 생성:** `ticketTypeIdGnrService` (TTYP-00001~)

---

### 1-2. SCHEDULE 테이블 확장 — GAP #3 해소

정원을 온라인/오프라인으로 분리.

**추가 컬럼:**
| 컬럼 | 설명 |
|------|------|
| ONLINE_CAPACITY | 온라인 정원 (한도) |
| OFFLINE_CAPACITY | 오프라인 정원 (한도) |
| ONLINE_AVAIL | 온라인 잔여석 |
| OFFLINE_AVAIL | 오프라인 잔여석 |
| SESSION_NO | 회차번호 (1, 2, 3...) |

- 기존 `TOTAL_SEATS` / `AVAIL_SEATS`는 전체 합산용으로 유지
- `TOTAL_SEATS = ONLINE_CAPACITY + OFFLINE_CAPACITY`
- `AVAIL_SEATS = ONLINE_AVAIL + OFFLINE_AVAIL`

---

### 1-3. 회차별 가격 테이블 신설 — GAP #4 해소

`SESSION_PRICE` 테이블로 회차 × 권종 = 가격 다대다 관계 구현.

**DB 테이블:** `SESSION_PRICE`
| 컬럼 | 설명 |
|------|------|
| SPRICE_ID | PK (SPRC-00001) |
| SCHEDULE_ID | FK → SCHEDULE |
| TICKET_TYPE_ID | FK → TICKET_TYPE |
| PRICE | 해당 회차/권종의 가격 |
| REG_DT | 등록일 |

**파일 구조:**
```
com/ftk/sessionprice/
├── vo/SessionPriceVO.java
├── mapper/SessionPriceMapper.java
├── service/SessionPriceService.java
├── service/SessionPriceServiceImpl.java
└── controller/SessionPriceController.java

resources/mapper/sessionprice/SessionPrice_SQL.xml
WEB-INF/jsp/ftk/sessionprice/sessionPriceList.jsp
```

**주요 URL:**
- `/sessionPriceList.do` — 회차별 가격 관리 (시간표 그리드 UI)
- `/saveSessionPrices.do` — 일괄 저장 (AJAX)
- `/applyDefaultPrices.do` — 기본가격 일괄 적용 (AJAX)

**핵심 기능:**
- 프로그램/날짜 필터 → 회차 × 권종 그리드로 가격 일괄 편집
- 기본가격(TicketPrice) 일괄 적용 후 개별 수정 가능
- 회차별, 요일별로 금액 개별 수정 → **GAP #4, #5 동시 해소**

**ID 생성:** `sessionPriceIdGnrService` (SPRC-00001~)

---

## Phase 2: 회차 자동 생성 UI — GAP #2 해소

### 벌크 생성 기능

일정 목록 페이지(`scheduleList.jsp`)에 **일괄 생성 모달** 추가.

**입력 파라미터:**
| 항목 | 설명 |
|------|------|
| 프로그램 | 대상 프로그램 선택 |
| 시작일 ~ 종료일 | 생성 기간 (예: 2026-01-01 ~ 2026-12-31) |
| 시작시간 ~ 종료시간 | 영업시간 (영업시간 설정에서 자동 로드) |
| 회차 단위 (분) | 60분, 90분 등 |
| 온라인 정원 / 오프라인 정원 | 회차별 정원 |

**처리 로직 (ScheduleController.generateScheduleBulk):**
1. 시작일~종료일 사이 모든 날짜 순회
2. **휴무일(HOLIDAY) 자동 제외** — HolidayService 연동
3. 각 날짜에 시작시간~종료시간을 회차 단위로 분할하여 SCHEDULE 레코드 생성
4. SESSION_NO 자동 부여 (1, 2, 3...)
5. 결과 메시지: "180건 생성 (휴무일 3일 제외)" 형태

**주요 URL:**
- `/generateScheduleBulk.do` — 벌크 생성 (POST, AJAX)

---

## Phase 3: 상품 유형 분리 — GAP #1, #8 해소

### PROGRAM_TYPE 확장

`PROGRAM` 테이블의 `PROGRAM_TYPE` 값을 비즈니스 요구에 맞게 재정의:

| PROGRAM_TYPE | 용도 | 회차 | 정원 |
|--------------|------|------|------|
| SESSION | 회차 입장권 (수영장, 케이블카 등) | O | O |
| ADMISSION | 일반 입장권 (수목원 등) | X | X |
| PRODUCT | 상품 (매점 물품 판매) | X | X |

**메뉴 분리:** 사이드바에서 상품 유형별 별도 메뉴로 접근 가능

### 상품(Product) 가격 테이블

**DB 테이블:** `PRODUCT_PRICE`
| 컬럼 | 설명 |
|------|------|
| PPRICE_ID | PK (PPRC-00001) |
| PROGRAM_ID | FK → PROGRAM |
| TICKET_TYPE_ID | FK → TICKET_TYPE |
| PRICE | 가격 |

**파일 구조:**
```
com/ftk/productprice/
├── vo/ProductPriceVO.java
├── mapper/ProductPriceMapper.java
├── service/ProductPriceService.java
├── service/ProductPriceServiceImpl.java
└── controller/ProductPriceController.java

resources/mapper/productprice/ProductPrice_SQL.xml
```

---

## Phase 4: 부가 기능

### 4A. 휴무일 관리 — GAP #9 부분 해소

휴무일/공휴일/특별 휴무를 등록하고, 회차 자동 생성 시 자동 제외.

**DB 테이블:** `HOLIDAY`
| 컬럼 | 설명 |
|------|------|
| HOLIDAY_ID | PK (HLDY-00001) |
| HOLIDAY_DATE | 휴무 날짜 |
| HOLIDAY_NM | 휴무명 (예: 설날, 정기휴무) |
| HOLIDAY_TYPE | 유형 (PUBLIC/REGULAR/SPECIAL) |
| USE_YN | 사용여부 |
| REMARK | 비고 |
| REG_DT | 등록일 |

**파일 구조:**
```
com/ftk/holiday/
├── vo/HolidayVO.java
├── mapper/HolidayMapper.java
├── service/HolidayService.java
├── service/HolidayServiceImpl.java
└── controller/HolidayController.java

resources/mapper/holiday/Holiday_SQL.xml
WEB-INF/jsp/ftk/holiday/holidayList.jsp
```

**주요 URL:**
- `/holidayList.do` — 휴무일 목록 (Bootstrap 모달 CRUD)
- `/insertHoliday.do` — 등록 (AJAX)
- `/updateHoliday.do` — 수정 (AJAX)
- `/deleteHoliday.do` — 삭제 (AJAX)

**벌크 생성 연동:**
- `ScheduleController.generateScheduleBulk`에서 `HolidayService.selectHolidayDatesBetween()` 호출
- 생성 기간 내 휴무일을 Set으로 관리, 날짜 순회 시 일치하면 skip
- 응답에 제외 일수 포함: "180건 생성 (휴무일 3일 제외)"

**ID 생성:** `holidayIdGnrService` (HLDY-00001~)

---

### 4B. 영업시간 관리 — GAP #9 해소

요일별 영업시간을 설정하고, 회차 벌크 생성 시 자동 참조.

**DB 테이블:** `BUSINESS_HOURS`
| 컬럼 | 설명 |
|------|------|
| BH_ID | PK (BHRS-00001) |
| DAY_OF_WEEK | 요일 (1=월 ~ 7=일) |
| OPEN_TIME | 영업 시작 (HH:mm) |
| CLOSE_TIME | 영업 종료 (HH:mm) |
| USE_YN | 영업 여부 (N=휴무) |
| REG_DT | 등록일 |

**파일 구조:**
```
com/ftk/businesshours/
├── vo/BusinessHoursVO.java
├── mapper/BusinessHoursMapper.java
├── service/BusinessHoursService.java
├── service/BusinessHoursServiceImpl.java
└── controller/BusinessHoursController.java

resources/mapper/businesshours/BusinessHours_SQL.xml
WEB-INF/jsp/ftk/businesshours/businessHoursList.jsp
```

**주요 URL:**
- `/businessHoursList.do` — 영업시간 설정 (7행 고정 테이블)
- `/saveBusinessHours.do` — 전체 저장 (배열 파라미터, AJAX)
- `/businessHoursApi.do` — JSON API (벌크 생성 모달에서 호출)

**UI 특징:**
- 월~일 7행 고정, 각 행에 시작/종료 시간 + 토글 스위치
- 토요일=파란색, 일요일=빨간색 행 강조
- 영업시간 자동 계산 표시 (예: "9시간")
- 초기 진입 시 기본값 자동 생성 (월~일, 09:00~18:00)

**벌크 생성 연동:**
- `scheduleList.jsp`의 벌크 생성 모달에서 `/businessHoursApi.do` 호출
- 시작시간/종료시간 자동 채움

**ID 생성:** `businessHoursIdGnrService` (BHRS-00001~)

---

### 4C. 할인 정책 관리 — GAP #7 해소

정률(%) 또는 정액(원) 할인 정책을 등록. 현재는 기초 데이터 관리까지 구현 (실제 예약 적용은 후순위).

**DB 테이블:** `DISCOUNT`
| 컬럼 | 설명 |
|------|------|
| DISCOUNT_ID | PK (DCNT-00001) |
| DISCOUNT_NM | 할인명 |
| DISCOUNT_TYPE | PERCENT (정률) / AMOUNT (정액) |
| DISCOUNT_VALUE | 할인값 (10 = 10% 또는 10원) |
| START_DATE | 적용 시작일 (NULL 가능) |
| END_DATE | 적용 종료일 (NULL 가능) |
| USE_YN | 사용여부 |
| REMARK | 비고 |
| REG_DT | 등록일 |

**파일 구조:**
```
com/ftk/discount/
├── vo/DiscountVO.java
├── mapper/DiscountMapper.java
├── service/DiscountService.java
├── service/DiscountServiceImpl.java
└── controller/DiscountController.java

resources/mapper/discount/Discount_SQL.xml
WEB-INF/jsp/ftk/discount/discountList.jsp
```

**주요 URL:**
- `/discountList.do` — 할인 정책 목록 (Bootstrap 모달 CRUD)
- `/insertDiscount.do` — 등록 (AJAX)
- `/updateDiscount.do` — 수정 (AJAX)
- `/deleteDiscount.do` — 삭제 (AJAX)

**UI 특징:**
- 정률=파란 배지, 정액=노란 배지로 타입 구분
- 할인값 라벨 동적 변경 (% ↔ 원)
- 날짜 미입력 시 NULL 저장 (MSSQL 빈 문자열→1900-01-01 방지)

**ID 생성:** `discountIdGnrService` (DCNT-00001~)

---

## Phase 5: 온라인 예약 연동 — GAP #3, #10 해소

고객이 로그인 없이 접근하여 프로그램 → 날짜 → 회차 → 권종/수량 → 예약자 정보를 입력하고 예약하는 공개 페이지.

### 컨트롤러

**파일:** `com/ftk/onlinebooking/controller/OnlineBookingController.java`

**주요 URL:**
| URL | 메서드 | 설명 |
|-----|--------|------|
| `/onlineBooking.do` | GET | 메인 페이지 (SESSION 타입 프로그램 목록 로드) |
| `/onlineBookingDates.do` | GET | AJAX: 프로그램별 예약 가능 날짜 |
| `/onlineBookingSessions.do` | GET | AJAX: 날짜별 회차 목록 (잔여석 포함) |
| `/onlineBookingPrices.do` | GET | AJAX: 회차별 권종/가격 (SESSION_PRICE) |
| `/submitOnlineBooking.do` | POST | AJAX: 예약 처리 |

### 예약 처리 로직

```
1. 프론트에서 spriceIds, prices, qtys (콤마 구분) + 예약자정보 전송
2. 총 수량 합산 → 정원 확인
3. scheduleService.decreaseOnlineAvail() — 원자적 정원 차감
   SQL: UPDATE SCHEDULE SET ONLINE_AVAIL = ONLINE_AVAIL - #{qty}
        WHERE SCHEDULE_ID = #{id} AND ONLINE_AVAIL >= #{qty}
   → 영향 행 0이면 정원 초과 에러
4. BOOKING 레코드 생성 (BOOKING_CHANNEL = 'ONLINE')
5. BOOKING_DETAIL 레코드 생성 (권종별)
6. 예약번호 반환
```

### 정원 차감 원자성

- SQL `WHERE ONLINE_AVAIL >= #{qty}` 조건으로 동시성 제어
- UPDATE 영향 행이 0이면 즉시 실패 → 클라이언트에 "잔여석 부족" 메시지
- 당일 예약 차단: `EVENT_DATE > CAST(GETDATE() AS DATE)` — 오늘 이후 날짜만 노출

### BOOKING 테이블 확장

**추가 컬럼:**
| 컬럼 | 설명 |
|------|------|
| BOOKING_CHANNEL | 예약 경로 (ONLINE / OFFLINE) |

### JSP 페이지

**파일:** `WEB-INF/jsp/ftk/onlinebooking/onlineBooking.jsp`

**UI 특징:**
- 관리자 헤더/사이드바 **없음** — 독립된 고객용 페이지
- 파란 그라데이션 헤더 + "FastTicket 온라인 예약" 타이틀
- **5단계 위저드 UI:**
  1. 프로그램 선택 (드롭다운)
  2. 날짜 선택 (카드 그리드, 요일 표시)
  3. 회차 선택 (카드, 시간 + 잔여석 표시)
  4. 권종 및 수량 선택 (테이블, 실시간 소계/합계 계산)
  5. 예약자 정보 (이름*, 연락처*, 이메일)
- 예약 완료 시 결과 카드: 예약번호 + 매수 + 금액
- 하단 "관리자 로그인" 링크

### LoginInterceptor 제외 설정

`dispatcher-servlet.xml`에 온라인 예약 관련 5개 URL 제외:
```xml
<mvc:exclude-mapping path="/onlineBooking.do"/>
<mvc:exclude-mapping path="/onlineBookingDates.do"/>
<mvc:exclude-mapping path="/onlineBookingSessions.do"/>
<mvc:exclude-mapping path="/onlineBookingPrices.do"/>
<mvc:exclude-mapping path="/submitOnlineBooking.do"/>
```

### 테스트 결과 (Playwright, 2026-03-10)

| 테스트 항목 | 결과 |
|------------|------|
| 로그인 없이 페이지 접근 | ✅ 정상 |
| 프로그램 선택 → 날짜 로드 | ✅ 4개 날짜 표시 |
| 날짜 선택 → 회차 로드 | ✅ 09:00 1회차 / 잔여 30석 |
| 회차 선택 → 권종/가격 로드 | ✅ 어린이 5,000 / 청소년 7,000 / 경로 8,000 |
| 수량 입력 → 소계/합계 계산 | ✅ 3매 / 17,000원 |
| 확인 다이얼로그 | ✅ "총 3매를 예약하시겠습니까?" |
| 예약 완료 결과 | ✅ BOOK-00001, 3매/17,000원 |
| 정원 차감 확인 | ✅ 30석 → 27석 (3석 정확히 차감) |

---

## GAP 해소 매핑 요약

| GAP # | 요구사항 | 해소 Phase | 상태 |
|--------|----------|-----------|------|
| #1 | 상품 유형 구분 | Phase 3 | ✅ SESSION/ADMISSION/PRODUCT 분리 |
| #2 | 회차 자동 생성 | Phase 2 | ✅ 벌크 생성 + 휴무일 연동 |
| #3 | 온/오프라인 정원 분리 | Phase 1-2, 5 | ✅ ONLINE/OFFLINE_CAPACITY/AVAIL |
| #4 | 회차별 가격 | Phase 1-3 | ✅ SESSION_PRICE 테이블 |
| #5 | 요일별 가격 설정 | Phase 1-3 | ✅ 회차별 개별 수정으로 해소 |
| #6 | 커스텀 권종 관리 | Phase 1-1 | ✅ TICKET_TYPE 테이블 |
| #7 | 할인 정책 | Phase 4C | ✅ DISCOUNT 테이블 (기초 데이터) |
| #8 | 일반 입장권 UI 분리 | Phase 3 | ✅ ADMISSION 타입 별도 |
| #9 | 영업시간/휴무일 | Phase 4A, 4B | ✅ HOLIDAY + BUSINESS_HOURS |
| #10 | 용어 불일치 | 전체 | ✅ 공연장→장소, 공연일정→회차 등 |

---

## 전체 모듈 파일 목록

### 신규 모듈 (Phase 1~5에서 추가)

| 모듈 | Java 파일 수 | JSP | SQL XML | ID 접두어 |
|------|-------------|-----|---------|-----------|
| tickettype (권종) | 5 | 1 | 1 | TTYP- |
| sessionprice (회차별 가격) | 5 | 1 | 1 | SPRC- |
| productprice (상품 가격) | 5 | - | 1 | PPRC- |
| holiday (휴무일) | 5 | 1 | 1 | HLDY- |
| businesshours (영업시간) | 5 | 1 | 1 | BHRS- |
| discount (할인 정책) | 5 | 1 | 1 | DCNT- |
| onlinebooking (온라인 예약) | 1 | 1 | - | - |

### 수정된 기존 모듈

| 모듈/파일 | 변경 내용 |
|-----------|----------|
| schedule/ScheduleController | 벌크 생성 엔드포인트, 휴무일 연동 |
| schedule/ScheduleMapper | selectAvailableDates, selectAvailableSessions, decreaseOnlineAvail |
| schedule/ScheduleService(Impl) | 온라인 예약용 서비스 메서드 추가 |
| schedule/Schedule_SQL.xml | 벌크 생성, 예약 가능 날짜/회차, 정원 차감 쿼리 |
| schedule/scheduleList.jsp | 벌크 생성 모달, 영업시간 자동 로드 |
| booking/BookingVO | bookingChannel 필드 추가 |
| booking/Booking_SQL.xml | BOOKING_CHANNEL INSERT/SELECT 추가 |
| program/Program_SQL.xml | PROGRAM_TYPE 필터 쿼리 |

### 설정 파일 변경

| 파일 | 변경 내용 |
|------|----------|
| `context-idgen.xml` | 7개 IdGnrService 추가 (TTYP, SPRC, PPRC, HLDY, BHRS, DCNT 등) |
| `sql-mapper-config.xml` | typeAlias 추가 (ticketTypeVO, sessionPriceVO, holidayVO, businessHoursVO, discountVO 등) |
| `dispatcher-servlet.xml` | 온라인 예약 5개 URL LoginInterceptor 제외 |
| `mssql-schema.sql` | TICKET_TYPE, SESSION_PRICE, PRODUCT_PRICE, HOLIDAY, BUSINESS_HOURS, DISCOUNT 테이블 + SCHEDULE/BOOKING 컬럼 추가 + MENU 데이터 |

---

## 미구현 / 후순위 항목

| 항목 | 설명 | 우선순위 |
|------|------|----------|
| 할인 정책 실제 적용 | DISCOUNT → 예약 시 가격 할인 연동 | 중 |
| 온라인 미판매분 오프라인 전환 | 당일 온라인 잔여 → 오프라인으로 자동 이관 | 중 |
| 오프라인(현장) 발권 페이지 | POS 형태의 현장 발권 UI | 중 |
| 상품(매점) 판매 UI | 기존 시스템 카피 수준 | 낮음 |
| 요일별 영업시간 벌크 생성 연동 | 현재 단일 시간대만 지원, 요일별 다른 시간대 벌크 생성 | 낮음 |
| 예약 취소/환불 | 온라인 예약 취소 시 정원 복원 | 중 |
| 이메일/SMS 예약 확인 | 예약 완료 시 알림 발송 | 낮음 |
