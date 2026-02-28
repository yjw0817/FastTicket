-- ============================================================
-- SAMPLE 테이블 (MariaDB용)
-- 기존 HSQLDB용 sampledb.sql의 MariaDB 호환 버전
-- ============================================================

CREATE TABLE IF NOT EXISTS SAMPLE (
    ID          VARCHAR(16)  NOT NULL,
    NAME        VARCHAR(50),
    DESCRIPTION VARCHAR(100),
    USE_YN      CHAR(1),
    REG_USER    VARCHAR(10),
    PRIMARY KEY (ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='샘플';

CREATE TABLE IF NOT EXISTS IDS (
    TABLE_NAME VARCHAR(16)  NOT NULL,
    NEXT_ID    DECIMAL(30)  NOT NULL,
    PRIMARY KEY (TABLE_NAME)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ID 생성 시퀀스';

-- SAMPLE 초기 데이터 (기존 데이터가 없을 때만)
INSERT IGNORE INTO SAMPLE VALUES('SAMPLE-00001','Runtime Environment','Foundation Layer','Y','eGov');
INSERT IGNORE INTO SAMPLE VALUES('SAMPLE-00002','Runtime Environment','Persistence Layer','Y','eGov');
INSERT IGNORE INTO SAMPLE VALUES('SAMPLE-00003','Runtime Environment','Presentation Layer','Y','eGov');
INSERT IGNORE INTO SAMPLE VALUES('SAMPLE-00004','Runtime Environment','Business Layer','Y','eGov');
INSERT IGNORE INTO SAMPLE VALUES('SAMPLE-00005','Runtime Environment','Batch Layer','Y','eGov');

-- SAMPLE ID 시퀀스
INSERT IGNORE INTO IDS (TABLE_NAME, NEXT_ID) VALUES ('SAMPLE', 6);
