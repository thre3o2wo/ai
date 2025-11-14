-- [II] SELECT문 - 조회

-- 1. SELECT 문장 작성법
    SELECT * FROM TAB; -- 현 계정(SCOTT)이 가지고 있는 테이블 정보(실행: ctrl+enter)
    SELECT * FROM DEPT; -- DEPT 테이블의 모든 열, 모든 행
    SELECT * FROM SALGRADE; -- SALGRADE 테이블의 모든 열 모든 행
    SELECT * FROM EMP; -- EMP 테이블이 모든 열, 모든 행

-- 2. 특정 열만 출력
    DESC EMP; 
        -- DESC 명령어는 대상 테이블의 구조를 나열. (같은 줄에 주석 넣으면 안 됨)
    -- EMP 테이블의 구조
    SELECT EMPNO, ENAME, SAL, JOB FROM EMP; -- EMP테이블 SELECT절의 지정된 열만 출력
    SELECT EMPNO AS "사번", ENAME AS "이름", SAL AS "급여", JOB AS "직책"
        FROM EMP; -- 열이름에 별칭을 두는 경우 : 열이름 AS "별칭" / 열이름 "별칭" 쌍따옴표는 여기서만 쓴다.
    SELECT EMPNO "사번", ENAME "이름", SAL, JOB FROM EMP; -- AS 생략
    SELECT EMPNO NO, ENAME NAME, SAL PAY, JOB ROLE FROM EMP; -- "따옴표"마저 생략 (별칭에 SPACE 없으면)

--3. 특정 행만 출력 : WHERE절(조건절) -- 비교연산자 : equal(=),0 differ(!=, ^=, <>), (>, >=, <=, <)
    SELECT EMPNO 사번, ENAME 이름, SAL 급여 FROM EMP WHERE SAL=3000;
    SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL!=3000;
    SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL^=3000;
    SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL<>3000;
    -- 비교연산자는 숫자, 문자, 날짜형 모두 가능.
    -- EX.1 사원 이름이 A, B, C로 시작하는 사원들의 모든 필드
        SELECT * FROM EMP WHERE ENAME < 'D'; --(A<AA<AAA<B<BA<C)
    -- EX.2 81년도 이전에 입사한 사원의 모든 필드
        SELECT * FROM EMP WHERE HIREDATE < '81/01/01';
    -- EX.3 부서번호(DEPTNO)가 10번인 사원의 모든 필드
        SELECT * FROM EMP WHERE DEPTNO = 10;
    -- SQL문은 대소문자 구별 없음. 물론 데이터는 대소문자 구별
    -- EX.4 이름(ENAME)이 SCOTT인 직원의 모든 데이터
        SELECT * FROM EMP WHERE ENAME='SCOTT'; -- scott 소문자로 적으면 안 나옴
        
-- 4. WHERE(조건절)에 논리 연산자 AND OR NOT 
    -- EX1. 급여가 2000이상, 300이하인 직원의 모든 필드
        SELECT * FROM EMP WHERE SAL>=2000 AND SAL<=3000;
    -- EX2. 82년도 입사한 사원의 모든 필드
        SELECT * FROM EMP WHERE HIREDATE>='82/01/01' AND HIREDATE<'83/01/01';
        -- 날짜 표기법 세팅 (현재:RR/MM/DD)
            ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';
            SELECT * FROM EMP;
        SELECT * FROM EMP WHERE HIREDATE>='01-01-1982' AND HIREDATE<'01-01-1983';
            ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
        -- TO_CHAR(컬럼, 형식)    
            SELECT * FROM EMP
                WHERE TO_CHAR(HIREDATE, 'RR/MM/DD')>='82/01/01'
                    AND TO_CHAR(HIREDATE, 'RR/MM/DD')<'83/01/01';
    -- EX3. 부서번호가 10이 아닌 직원의 모든 필드
        SELECT * FROM EMP WHERE DEPTNO != 10;
        SELECT * FROM EMP WHERE NOT DEPTNO = 10;

-- 5. 산술연산자 (SELECT절, WHERE절, ORDER BY절)
    SELECT EMPNO, ENAME, SAL "기존월급", SAL*1.1 "인상월급" FROM EMP;
    -- EX1. 연봉이 10,000 이상인 직원의 ENAME(이름), SAL(월급), 연봉 / 연봉순
        SELECT ENAME "이름", SAL "월급", SAL*12 "연봉" FROM EMP 
            WHERE SAL*12>=10000 ORDER BY "연봉";
    -- 연산 순서 : FROM → WHERE → SELECT → ORDER BY // 즉, SELECT절에서 정한 별칭을 WHERE에서 사용할 수 없다.
    -- EX2. 연봉이 20,000 이상인 직원의 이름, 월급, 상여, 연봉(SAL*12 + COMM)을 출력
        SELECT ENAME "이름", SAL "월급", COMM "상여", SAL*12+NVL(COMM,0) "연봉" FROM EMP 
            ORDER BY "연봉";
        -- 산술 연산의 결과는 NULL을 포함하면 결과도 NULL (COMM이 NULL인 데이터)
        -- NVL(NULL일 수도 있는 필드명, 대체값) 함수를 이용. 필드명과 대체값은 타입이 일치해야 한다.
    -- EX3. 모든 사원의 ENAME, MGR(상사사번)을 출력, MGR이 NULL이면 'CEO'라고 출력.
        SELECT ENAME, NVL(TO_CHAR(MGR), 'CEO') MGR FROM EMP;
        
-- 6. 연결연산자 (||) : 필드 내용이나 문자를 연결
    SELECT ENAME || '은(는) ' || JOB FROM EMP;


-- CH2 총 연습문제 PART2
    -- Q1. emp 테이블의 구조 출력
        DESC EMP;
    -- Q2. emp 테이블의 모든 내용을 출력 
        SELECT * FROM EMP;
    -- Q3. 현 scott 계정에서 사용가능한 테이블 출력
        SELECT * FROM TAB;
    -- Q4. emp 테이블에서 사번, 이름, 급여, 업무, 입사일 출력
        SELECT EMPNO, ENAME, SAL, JOB, HIREDATE FROM EMP;
    -- Q5. emp 테이블에서 급여가 2000미만인 사람의 사번, 이름, 급여 출력
        SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL<2000;
    -- Q6. 입사일이 81/02이후에 입사한 사람의 사번, 이름, 업무, 입사일 출력
        SELECT EMPNO, ENAME, JOB, HIREDATE FROM EMP WHERE HIREDATE>='81/02/01';
        SELECT EMPNO, ENAME, JOB, HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM')>='81/02';
    -- Q7. 업무가 SALESMAN인 사람들 모든 자료 출력
        SELECT * FROM EMP WHERE JOB='SALESMAN';
    -- Q8. 업무가 CLERK이 아닌 사람들 모든 자료 출력
        SELECT * FROM EMP WHERE JOB!='CLERK';
    -- Q9. 급여가 1500이상이고 3000이하인 사람의 사번, 이름, 급여 출력
        SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL>=1500 AND SAL<=3000;
    -- Q10. 부서코드가 10번이거나 30인 사람의 사번, 이름, 업무, 부서코드 출력
        SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP WHERE DEPTNO!=20;
    -- Q11. 업무가 SALESMAN이거나 급여가 3000이상인 사람의 사번, 이름, 업무, 부서코드 출력
        SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP WHERE JOB='SALESMAN' OR SAL >= 3000;
    -- Q12. 급여가 2500이상이고 업무가 MANAGER인 사람의 사번, 이름, 업무, 급여 출력
        SELECT EMPNO, ENAME, JOB, SAL FROM EMP WHERE SAL >=2500 AND JOB='MANAGER';
    -- Q13.“ename은 XXX 업무이고 연봉은 XX다” 스타일로 모두 출력(연봉은 SAL*12+COMM)
        SELECT ENAME || '은 ' || JOB || ' 업무이고 연봉은 ' || (SAL*12+NVL(COMM,0)) || '이다.' "설명" FROM EMP;

    
-- 7. 중복제거 (DISTICT)
    SELECT DISTINCT JOB FROM EMP;
    SELECT DISTINCT DEPTNO FROM EMP;
    
-- 8. SQL연산자 (BETWEEN, IN, LIKE, IS NULL)
    -- 8.1. BETWEEN A AND B : A부터 B까지 (A, B 포함. A<=B)
        -- 비교연산자와 논리연산자의 쿵짝
        -- EX1. SAL이 1500 이상 3000 이하
            SELECT * FROM EMP WHERE SAL>=1500 AND SAL<=3000;
            SELECT * FROM EMP WHERE SAL BETWEEN 1500 AND 3000;
            SELECT * FROM EMP WHERE SAL BETWEEN 3000 AND 1500; --XX 순서 주의
        -- EX1-1. SAL이 1500 미만 3000 초과 (EX1의 여집합)
            SELECT * FROM EMP WHERE SAL<1500 OR SAL>3000;
            SELECT * FROM EMP WHERE SAL NOT BETWEEN 1500 AND 3000;
        -- EX2. 81년도 봄(3~5월)에 입사한 직원의 모든 필드
            SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') BETWEEN '81/03/01' AND '81/05/31';
    -- 8.2. IN 연산자 : 필드명 IN (값1, 값2, ..., 값N)
        -- EX1. 부서코드가 10번이거나 30이거나 40인 사람의 모든 정보
            SELECT * FROM EMP WHERE DEPTNO=10 OR DEPTNO=30 OR DEPTNO = 40;
            SELECT * FROM EMP WHERE DEPTNO IN (10, 30, 40);
        -- EX1-1. EX1의 반대
            SELECT * FROM EMP WHERE DEPTNO NOT IN (10, 30, 40);
        -- EX2. 직책(JOB)이 'MANAGER'이거나 'ANALYST'인 사원의 모든 정보
            SELECT * FROM EMP WHERE JOB IN ('MANAGER', 'ANALYST');
        -- EX2-1. EX2의 반대
            SELECT * FROM EMP WHERE JOB NOT IN ('MANAGER', 'ANALYST');
    -- 8.3. LIKE 연산자 : 필드명 LIKE '패턴'
        -- % : 0글자 이상 포함 / _ : 한 글자 포함
        -- EX1. 이름이 M으로 시작하는 사원의 모든 정보
            SELECT * FROM EMP WHERE ENAME LIKE 'M%';
        -- EX2. 이름이 S로 끝나는 사원의 모든 정보
            SELECT * FROM EMP WHERE ENAME LIKE '%S';
        -- EX3. 이름에 N이 들어가는 사원의 모든 정보
            SELECT * FROM EMP WHERE ENAME LIKE '%N%';
        -- EX4. 이름에 N이 들어가고 JOB에 S가 들어가는 사원의 모든 정보
            SELECT * FROM EMP WHERE ENAME LIKE '%N%' AND JOB LIKE '%S%';
        -- EX5. SAL이 5로 끝나는 사원의 모든 정보
            SELECT * FROM EMP WHERE SAL LIKE '%5';
        -- EX6. 82년도 입사한 사원
            SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '82/%';
            SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR')= '82';
        -- EX7. 1월에 입사한 사원
            SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') LIKE '__/01/__'; -- '%/01/%'
            SELECT * FROM EMP WHERE TO_CHAR(HIREDATE, 'MM') = '01';
        -- EX8. 이름에 %가 들어간 사원
                -- 이름에 %가 들어간 사원 데이터 INSERT (DML. 추후 자세히)
                    DESC EMP;
                    INSERT INTO EMP VALUES (9999, '홍%동', NULL, NULL, NULL, 9000, 9000, 40); 
                    -- EMPNO : NOT NULL, NUMBER (4)
                    -- ENAME : VARCHAR2(10) : 이 오라클 버전에서 한글 1자 3BYTE(4자 이상은 안 됨)
            SELECT * FROM EMP;
            SELECT * FROM EMP WHERE ENAME LIKE '%\%%' ESCAPE '\';
            ROLLBACK; -- DML(데이터조작어; 추가/수정/삭제/검색)을 취소
                -- '홍%동' INSERT 취소
    -- 8.4. 필드명 IS NULL : 필드명이 NULL인지 검색할 때
        -- EX1. COMM(상여) 없는 사원
            SELECT * FROM EMP WHERE COMM IS NULL OR COMM = 0; -- WHERE COMM=NULL로는 조회 안 됨
        -- EX2. COMM을 받는 사원(COMM이 0도 NULL도 아님)
            SELECT * FROM EMP WHERE COMM IS NOT NULL AND COMM != 0;
                -- WHERE 필드명 NOT IS NULL은 에러. WHERE NOT 필드명 IS NULL은 가능.

-- 9. 정렬(오름차순/내림차순)
    SELECT * FROM EMP ORDER BY SAL; -- 오름차순
    SELECT * FROM EMP ORDER BY SAL DESC; -- 내림차순
        -- EX1. SAL 내림차순, 같으면 HIREDATE 내림차순
            SELECT * FROM EMP ORDER BY SAL DESC, HIREDATE DESC;
        -- EX2. SAL 2000 초과하는 사원을 출력, ENAME 오름차순
            SELECT * FROM EMP WHERE SAL > 2000 ORDER BY ENAME;


  
---- CH2 총 연습문제 PART2

    -- 1. EMP 테이블에서 sal이 3000이상인 사원의 empno, ename, job, sal을 출력
        SELECT EMPNO, ENAME, JOB, SAL 
            FROM EMP 
            WHERE SAL >= 3000;
    -- 2. EMP 테이블에서 empno가 7788인 사원의 ename과 deptno를 출력
        SELECT ENAME, DEPTNO 
            FROM EMP 
            WHERE EMPNO=7788;
    -- 3. 연봉(SAL*12+COMM)이 24000이상인 사번, 이름, 급여 출력 (급여순정렬)
        SELECT EMPNO, ENAME, SAL 
            FROM EMP 
            WHERE SAL*12 + NVL(COMM,0) >= 24000 
            ORDER BY SAL;
    -- 4. 입사일이 1981년 2월 20과 1981년 5월 1일 사이에 입사한 사원의 사원명, 직책, 입사일을 출력 (단 hiredate 순으로 출력)
        SELECT ENAME, JOB, HIREDATE 
            FROM EMP
            WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') BETWEEN '81/02/20' AND '81/05/01'
            ORDER BY HIREDATE;
    -- 5. deptno가 10,20인 사원의 모든 정보를 출력 (단 ename순으로 정렬)
        SELECT * 
            FROM EMP
            WHERE DEPTNO IN (10, 20)
            ORDER BY ENAME;
    -- 6. sal이 1500이상이고 deptno가 10,30인 사원의 ename과 sal를 출력 (단 출력되는 결과의 타이틀을 employee과 Monthly Salary로 출력)
        SELECT ENAME employee, SAL "MONTHLY SALARY"
            FROM EMP
            WHERE DEPTNO IN (10, 30);
    -- 7. hiredate가 1982년인 사원의 모든 정보를 출력
        SELECT *
            FROM EMP
            WHERE TO_CHAR(HIREDATE, 'RR')='82';
    -- 8. 이름의 첫자가 C부터 P로 시작하는 사람의 이름, 급여. 이름순 정렬
        SELECT ENAME, SAL
            FROM EMP
            WHERE ENAME BETWEEN 'C' AND 'Q' AND ENAME!='Q'
            ORDER BY ENAME, SAL;
    -- 9. comm이 sal보다 10%가 많은 모든 사원에 대하여 이름, 급여, 상여금을 출력하는 SELECT 문을 작성
        SELECT ENAME, SAL, COMM
            FROM EMP
            WHERE COMM >= SAL*1.1;
            -- WHERE NVL(COMM,0) >= SAL*1.1; 굳이 NVL 안 씌워도 되는 케이스.
    -- 10. job이 CLERK이거나 ANALYST이고 sal이 1000,3000,5000이 아닌 모든 사원의 정보를 출력
        SELECT *
            FROM EMP
            WHERE JOB IN ('CLERK', 'ANALYST') AND SAL NOT IN (1000, 3000, 5000);
    -- 11. ename에 L이 두 자가 있고 deptno가 30이거나 또는 mgr이 7782인 사원의 모든 정보를 출력하는 SELECT 문을 작성하여라.
        SELECT *
            FROM EMP
            WHERE ENAME LIKE '%L%L%' AND DEPTNO=30 OR MGR=7782;
    -- 12. 입사일이 81년도인 직원의 사번, 사원명, 입사일, 업무, 급여를 출력
        SELECT EMPNO, ENAME, HIREDATE, JOB, SAL
            FROM EMP
            WHERE TO_CHAR(HIREDATE, 'RR') = '81';
    -- 13. 입사일이 81년이고 업무가 'SALESMAN'이 아닌 직원의 사번, 사원명, 입사일, 업무, 급여를 검색하시오.
        SELECT EMPNO, ENAME, HIREDATE, JOB, SAL
            FROM EMP
            WHERE TO_CHAR(HIREDATE, 'RR') = '81' AND JOB != 'SALESMAN';
    -- 14. 사번, 사원명, 입사일, 업무, 급여를 급여가 높은 순으로 정렬하고, 급여가 같으면 입사일이 빠른 사원으로 정렬하시오.
        SELECT EMPNO, ENAME, HIREDATE, JOB, SAL
            FROM EMP
            ORDER BY SAL DESC, TO_CHAR(HIREDATE, 'RR/MM/YY');
    -- 15. 사원명의 세 번째 알파벳이 'N'인 사원의 사번, 사원명을 검색하시오
        SELECT EMPNO, ENAME
            FROM EMP
            WHERE ENAME LIKE '__N%';
    -- 16. 사원명에 'A'가 들어간 사원의 사번, 사원명을 출력
        SELECT EMPNO, ENAME
            FROM EMP
            WHERE ENAME LIKE '%A%';
    -- 17. 연봉(SAL*12)이 35000 이상인 사번, 사원명, 연봉을 검색 하시오.
        SELECT EMPNO, ENAME, SAL*12 ANNUAL
            FROM EMP
            WHERE SAL*12 >= 35000;