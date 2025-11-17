-- [IV] DDL, DCL, DML

/* SQL
    (1) DCL (Data Control Language) :
        사용자 계정 생성 CREATE USER     권한부여         GRANT
        권한 박탈       REVOKE          사용자 계정 삭제  DROP USER
        트랜잭션 명령어  ROLLBACK, COMMIT
    (2) DDL (Data Definition Language) :
        테이블 생성     CREATE TABLE    테이블 구조 변경  ALTER TABLE
        테이블 삭제     DROP TABLE      
    (3) DML (Data Manipulation Language) - CRUD :
        입력           INSERT          검색            SELECT
        수정           UPDATE          삭제            DELETE
        - DML은 취소 가능
*/

-- ▷▶▷▶ DDL ◀◁◀◁

    -- 1. 테이블 생성 (CREATE TABLE 테이블명...) : 테이블의 구조를 정의
        -- ORACLE의 데이터 타입들 : NUMBER(38 이하의 자릿수), DATE, VARCHAR2(4000 이하의 바이트수),
        --                       CLOB - 4000 이상도 기록 가능한 VACHAR2
    
        CREATE TABLE BOOK(
            BOOKID NUMBER(4),       -- BOOKID 필드 타입 숫자 4자리
            BOOKNAME VARCHAR2(20),  -- BOOKNAME 필드 타입 문자 20바이트 (한글 1자 = 3BYTE)
            PUBLISHER VARCHAR2(20),
            RDATE DATE,             -- RDATE 필드 타입 DATE형(날짜+시간)
            PRICE NUMBER(8,2),       -- PRICE 필드 타입 숫자 전체 8자리 중 소수점 2자리
            PRIMARY KEY(BOOKID)     -- 제약조건: BOOKID를 주 키(PRIMARY KEY) 필드로 생성
        );
        SELECT * FROM BOOK;
        DESC BOOK;
    
    -- 2. 테이블 삭제 (DROP TABLE 테이블명)
        DROP TABLE BOOK;
            -- 재생성
        CREATE TABLE BOOK(
            BOOKID NUMBER(4) PRIMARY KEY,
            BOOKNAME VARCHAR2(20),
            PUBLISHER VARCHAR2(20),
            RDATE DATE,
            PRICE NUMBER(8,2)
        );
    
        SELECT * FROM EMP;
        SELECT * FROM DEPT;     -- DEPTNO 10, 20, 30, 40
        INSERT INTO EMP VALUES (7369, 'GILDONG', NULL, NULL, NULL, NULL, NULL, 50); -- 에러!
            -- 에러1. PRIMARY KEY는 UNIQUE CONSTRAINT. (중복)
            -- 에러2. PARENTKEY INVALID : DEPTNO 50는 없어.
    
    -- DEPT와 유사한 DEPT01 생성 : DEPTNO(2자리 숫자-PK), DNAME(14자 문자), LOC(13자 문자)
        DESC DEPT;
        CREATE TABLE DEPT01(
            DEPTNO NUMBER(2) PRIMARY KEY,
            DNAME VARCHAR2(14),
            LOC VARCHAR2(13)
        );
        INSERT INTO DEPT01 VALUES (10, '전산실', '신림');
        SELECT * FROM DEPT01;
        ROLLBACK; --DML 취소 가능
    
    -- EMP와 유사한 EMP01 생성 : EMPNO(4자리 숫자-PK), ENAME(10자 문자), HIREDATE(날짜), 
    --                         SAL(7자리 2소수점 숫자), DEPTNO(2자리 숫자-FK) FOREIGN KEY
        DESC EMP;
        CREATE TABLE EMP01(
            EMPNO NUMBER(4) PRIMARY KEY,
            ENAME VARCHAR2(10),
            HIREDATE DATE,
            SAL NUMBER(7,2),
            DEPTNO NUMBER(2) REFERENCES DEPT01(DEPTNO) -- 외래 키(FOREIGN KEY) 제약조건
        );
        DROP TABLE EMP01; -- 삭제 후 재생성
        CREATE TABLE EMP01(
            EMPNO NUMBER(4),
            ENAME VARCHAR2(10),
            HIREDATE DATE,
            SAL NUMBER(7,2),
            DEPTNO NUMBER(2),
            FOREIGN KEY(DEPTNO) REFERENCES DEPT01(DEPTNO),
            PRIMARY KEY(EMPNO)
        );
        SELECT * FROM EMP01;
        INSERT INTO EMP01 VALUES (1001, 'GILDONG', SYSDATE, 9999, 10);
        COMMIT; -- 트랜잭션 영역에 쌓여 있는 DML 명령어들을 ORACLE에 일괄 적용 - ROLLBACK 불가능


-- ▷▶▷▶ DML ◀◁◀◁

    -- 1. INSERT INTO 테이블명(필드명1, 필드명2, ...) VALUES (값1, 값2, ...);
        -- 1-1. INSERT INTO 테이블명 VALUES(값1, 값2, ... 값N);
            SELECT * FROM DEPT01;
            INSERT INTO DEPT01 VALUES (50, 'ACCOUNTING', 'SEOUL'); -- 필드명 없이 입력할 때는 순서 유의
            INSERT INTO DEPT01 (DEPTNO, LOC, DNAME) VALUES (60, '신림', '개발');
            INSERT INTO DEPT01 (DEPTNO, LOC, DNAME) VALUES (70, NULL, '영업'); -- 명시적으로 NULL 입력
            INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES(80, '연구'); -- 묵시적으로 LOC 필드 NULL 입력
        -- 1-2. 서브쿼리를 이용한 INSERT
            -- EX. DEPT 테이블의 20~40부서 내용을 그대로 DEPT01 테이블에 INSERT
                INSERT INTO DEPT01 SELECT * FROM DEPT WHERE DEPTNO>10;
        -- DDL 연습문제 PAGE1 : SAM01 테이블
            DROP TABLE SAM01;
            CREATE TABLE SAM01(
                EMPNO NUMBER(4) PRIMARY KEY,
                ENAME VARCHAR2(10),
                JOB VARCHAR2(9),
                SAL NUMBER(7,2)
            );
            SELECT * FROM SAM01;
            INSERT INTO SAM01 VALUES(1000, 'APPLE', 'POLICE', 10000);
            INSERT INTO SAM01 VALUES(1010, 'BANANA', 'NURSE', 15000);
            INSERT INTO SAM01 VALUES(1020, 'ORANGE', 'DOCTOR', 25000);
            INSERT INTO SAM01 VALUES(1030, 'VERY', NULL, 25000);
            INSERT INTO SAM01 VALUES(1040, 'CAT', NULL, 2000);
            INSERT INTO SAM01 SELECT EMPNO, ENAME, JOB, SAL FROM EMP WHERE DEPTNO=10;
            COMMIT;

    -- 2. UPDATE 테이블명 SET 필드명1=값1[, 필드명2=값2, ... 필드명N=값N] [WHERE 조건];
        DROP TABLE EMP01;
        -- 서브쿼리를 이용한 테이블 생성 (제약조건 제외된 데이터만 가져옴)
            CREATE TABLE EMP01 AS SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP;
            SELECT * FROM EMP01;
        -- EX. 부서번호를 30번으로 수정
            UPDATE EMP01 SET DEPTNO=30;
            SELECT * FROM EMP01;
            ROLLBACK;
        -- EX. 모든 사원(EMP01)의 급여(SAL)를 10% 인상
            UPDATE EMP01 SET SAL = SAL*1.1;
            SELECT * FROM EMP01;
            ROLLBACK;
        -- EX. EMP01 테이블의 10번 부서 직원들을 30번 부서로
            UPDATE EMP01 SET DEPTNO=30 WHERE DEPTNO=10;
            SELECT * FROM EMP01;
            ROLLBACK;
        -- EX. SCOTT의 부서번호를 10으로, JOB은 'MANAGER'로, SAL과 COMM은 500$씩 인상
            -- 입사일은 오늘 일자로, 상사는 'KING'으로 수정.
            UPDATE EMP SET DEPTNO=10, JOB='MANAGER', 
                            SAL = SAL + 500,
                            COMM = NVL(COMM,0) + 500,
                            -- HIREDATE = TO_DATE('25/11/17', 'RR/MM/DD'),
                            HIREDATE = SYSDATE, -- SYSDATE: 지금
                            MGR = (SELECT EMPNO FROM EMP WHERE ENAME='KING')
                WHERE ENAME='SCOTT';
            SELECT * FROM EMP;
        -- EX. 모든 사원의 급여와 입사일을 'KING'의 급여와 입사일로 수정
            UPDATE EMP 
                SET SAL = (SELECT SAL FROM EMP WHERE ENAME='KING'),
                    HIREDATE = (SELECT HIREDATE FROM EMP WHERE ENAME='KING');
            UPDATE EMP
                SET (SAL, HIREDATE) = (SELECT SAL, HIREDATE FROM EMP WHERE ENAME='KING');
            ROLLBACK;
            
    -- 3. DELETE FROM 테이블명 [WHERE 조건];
        DELETE FROM EMP01;
        SELECT * FROM EMP01;
        ROLLBACK; -- INSERT/UPDATE/DELETE만 취소 가능
        DELETE FROM DEPT; -- 에러 : child record found (EMP 테이블에 참조된 데이터가 있어서)
        -- EX. EMP01에서 'FORD' 직원 퇴사
            DELETE FROM EMP01 WHERE ENAME='FORD';
        -- EX. EMP01에서 30번 부서 직원을 삭제
            DELETE FROM EMP01 WHERE DEPTNO=30;
        -- EX. 부서명이 RESEARCH 부서인 직원을 삭제
            DELETE FROM EMP01 WHERE DEPTNO = (SELECT DEPTNO FROM DEPT WHERE DNAME = 'RESEARCH');
            SELECT * FROM EMP01;
        -- EX. SAM01 테이블에서 JOB이 정해지지 않은 사원 삭제
            SELECT * FROM SAM01;
            DELETE FROM SAM01 WHERE JOB IS NULL;
        -- EX. SAM01 테이블에서 이름이 ORANGE인 데이터 삭제
            DELETE FROM SAM01 WHERE ENAME = 'ORAGNGE';
            SELECT * FROM SAM01;
        ROLLBACK;
        
    -- DDL, DML 연습문제 PAGE2 : MY_DATA 테이블
        -- (1)
            DROP TABLE MY_DATA;
            CREATE TABLE MY_DATA(
                ID NUMBER(4) PRIMARY KEY,
                NAME VARCHAR2(10),
                USERID VARCHAR2(30),
                SALARY NUMBER(10,2)
            );
        -- (2)
            INSERT INTO MY_DATA VALUES(1, 'Scott', 'sscott', 10000);
            INSERT INTO MY_DATA VALUES(2, 'Ford', 'fford', 13000);
            INSERT INTO MY_DATA VALUES(3, 'Patel', 'ppatel', 33000);
            INSERT INTO MY_DATA VALUES(4, 'Report', 'rreport', 23500);
            INSERT INTO MY_DATA VALUES(5, 'Good', 'ggood', 44450);
        -- (3)
            SELECT ID "ID - number(4)", 
                   NAME "NAME - varchar2(10)", 
                   USERID "USERID - varchar2(30)", 
                   TO_CHAR(SALARY, '99,999,999.99') "SALARY - number(10,2)" 
                FROM MY_DATA;
        -- (4)
            COMMIT;
        -- (5)            
            UPDATE MY_DATA SET SALARY=65000 WHERE ID=3;
        -- (6)
            DELETE FROM MY_DATA WHERE NAME='Ford';
            COMMIT;
        -- (7)
            UPDATE MY_DATA SET SALARY=15000 WHERE SALARY>=15000;
        SELECT * FROM MY_DATA;
        -- (8)
            DROP TABLE MY_DATA;
            
    -- DML 연습문제 PAGE3
        -- (1)
            DROP TABLE EMP01;
            CREATE TABLE EMP01 AS SELECT * FROM EMP;
            UPDATE EMP01 SET DEPTNO=30;
        -- (2)
            UPDATE EMP01 SET SAL=SAL*1.1;
        -- (3)
            UPDATE EMP01 SET SAL=SAL*1.1 WHERE SAL>=3000;
        -- (4)
            SELECT * FROM DEPT;
            UPDATE EMP01 SET SAL=SAL+1000 WHERE DEPTNO=(SELECT DEPTNO FROM DEPT WHERE LOC='DALLAS');
        -- (5)
            UPDATE EMP01 SET DEPTNO=30, JOB='MANAGER' WHERE ENAME='SCOTT';
        -- (6)
            DELETE FROM EMP01 WHERE DEPTNO=(SELECT DEPTNO FROM DEPT WHERE DNAME='SALES');
        -- (7)
            DELETE FROM EMP01 WHERE ENAME='FORD';
        -- (8)
            DELETE FROM SAM01 WHERE JOB IS NULL;
        -- (9)
            DELETE FROM SAM01 WHERE ENAME='ORANGE';
        -- (10)
            UPDATE SAM01 SET SAL=1500 WHERE SAL<=1500;
        -- (11)
            UPDATE SAM01 SET SAL=SAL*0.9 WHERE JOB='MANAGER';
        ROLLBACK;
        SELECT * FROM EMP01;
        SELECT * FROM SAM01;


-- ▷▶▷▶ 제약조건 ◀◁◀◁
-- (1) PRIMARY KEY : 테이블이 각 행을 유일한 값으로 식별하기 위한 필드
-- (2) FOREIGN KEY : 테이블의 열이 다른 테이블의 열을 참조
-- (3) NOT NULL    : NULL을 포함하지 않는다.
-- (4) UNIQUE      : 모든 행의 값이 유일해야 한다. 단, NULL 값은 허용(중복도)
-- (5) CHECK(조건) : 해당 조건이 만족(NULL값 허용)
-- DEFAULT 기본값 : 기본값 설정(해당 열의 데이터를 입력하지 않고
              --  INSERT하면 NULL이 들어갈 것을 DEFAULT값이 들어가도록)

    -- DEPT1 & EMP1 테이블 생성
        CREATE TABLE DEPT1( -- 제약조건을 옆에 기술
            DEPTNO NUMBER(2)    PRIMARY KEY,
            DNAME VARCHAR2(14)  NOT NULL UNIQUE,
            LOC VARCHAR2(13)    NOT NULL
        );    
        CREATE TABLE EMP1( -- 제약조건을 옆에 기술
            EMPNO NUMBER(4)     PRIMARY KEY,
            ENAME VARCHAR2(20)  NOT NULL,
            JOB VARCHAR2(20)    NOT NULL,
            MGR NUMBER(4)       ,
            HIREDATE DATE       DEFAULT SYSDATE,
            SAL NUMBER(7,2)     CHECK(SAL>0),
            COMM NUMBER(7,2)    ,
            DEPTNO NUMBER(2)    REFERENCES DEPT1(DEPTNO)
        );
        SELECT * FROM DEPT1;
        SELECT * FROM EMP1;
    -- 두 테이블 삭제 후 제약조건을 아래에 기술
        DROP TABLE EMP1;
        DROP TABLE DEPT1;
        CREATE TABLE DEPT1( -- 제약조건을 아래에 기술
            DEPTNO NUMBER(2)    ,
            DNAME VARCHAR2(14)  NOT NULL,
            LOC VARCHAR2(13)    NOT NULL,
            PRIMARY KEY(DEPTNO) ,
            UNIQUE(DNAME)
        );
        CREATE TABLE EMP1( -- 제약조건을 아래에 기술
            EMPNO NUMBER(4)     ,
            ENAME VARCHAR2(20)  NOT NULL,
            JOB VARCHAR2(20)    NOT NULL,
            MGR NUMBER(4)       ,
            HIREDATE DATE       DEFAULT SYSDATE,
            SAL NUMBER(7,2)     ,
            COMM NUMBER(7,2)    ,
            DEPTNO NUMBER(2)    ,
            PRIMARY KEY(EMPNO),
            CHECK(SAL>0),
            FOREIGN KEY(DEPTNO) REFERENCES DEPT1(DEPTNO)
        );
    -- 데이터 입력 테스트
        INSERT INTO DEPT1 SELECT * FROM DEPT;
        INSERT INTO DEPT1 VALUES (50, 'SALES', '서울'); -- UNIQUE 에러
        INSERT INTO DEPT1 (DEPTNO, DNAME) VALUES (50, '전산'); -- NOT NULL 에러
        INSERT INTO EMP1 (EMPNO, ENAME, JOB, DEPTNO) VALUES(9001, 'GILDONG', 'MANAGER', 40); --DEFAULT 입력
        -- INSERT에서 언급되지 않은 필드는 NULL 값 입력
        SELECT * FROM EMP1;
        INSERT INTO EMP1 (EMPNO, ENAME, JOB, SAL) VALUES (9002, 'KIM', 'MANAGER', -90); -- check constraint
        INSERT INTO EMP1 (EMPNO, ENAME, JOB, SAL) VALUES (9002, 'KIM', 'MANAGER', 90);


    -- *EX MAJOR / STUDENT
        DROP TABLE MAJOR;
        DROP TABLE STUDENT;
        CREATE TABLE MAJOR(
            mCODE NUMBER(3) PRIMARY KEY,
            mNAME VARCHAR2(20),
            mOFFICE VARCHAR(20)
        );
        INSERT INTO MAJOR VALUES(1, '컴퓨터공학', 'A101호');
        INSERT INTO MAJOR VALUES(2, '빅데이터', 'A102호');
        SELECT * FROM MAJOR;
        CREATE TABLE STUDENT(
            sNO NUMBER(3) PRIMARY KEY,
            sNAME VARCHAR2(15),
            sSCORE NUMBER(3) CHECK (sSCORE BETWEEN 0 AND 100),
            mCODE NUMBER(3) REFERENCES MAJOR(mCODE)
        );
        INSERT INTO STUDENT VALUES(101, '홍길동', 99, 1);
        INSERT INTO STUDENT VALUES(102, '신길동', 100, 2);
        SELECT * FROM STUDENT;
        SELECT sNO "학번", sNAME "이름", sSCORE "점수", S.mCODE "학과코드", mNAME "학과명", mOFFICE "학과사무실"
            FROM MAJOR M, STUDENT S
            WHERE S.mCODE=M.mCODE;