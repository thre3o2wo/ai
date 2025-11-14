-- [III] JOIN : 2개 이상의 테이블을 연결하여 데이터를 검색하는 방법

    SELECT * FROM EMP; -- 사번, 이름, 업무, 상사사번, 입사일, 급여, 상여, 부서번호
    SELECT * FROM DEPT; -- 부서번호, 부서명, 부서위치
    -- 사번~부서번호, 부서명, 부서위치
        SELECT * FROM EMP, DEPT WHERE ENAME='SCOTT'; -- CROSS JOIN (무의미한 병합)'
    -- DEPTNO 일치 내용만 병합 (EQUI JOIN)
    SELECT * FROM EMP, DEPT WHERE ENAME='SCOTT' AND EMP.DEPTNO = DEPT.DEPTNO;

    
-- 1. EQUI JOIN ⭐⭐⭐ : 공통 필드값이 일치되는 조건만 JOIN
    SELECT *                                       -- (3)
        FROM EMP E, DEPT D                         -- (1) WHERE절 테이블의 별칭으로만 사용(30자 이하)
        WHERE ENAME='SCOTT' AND E.DEPTNO=D.DEPTNO; -- (2)
    SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, E.DEPTNO, DNAME, LOC --DEPTNO만 쓰면 ERROR
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO;
    -- EX1. SAL 2000 이상인 직원의 ENAME, JOB, SAL, DNAME, LOC
        SELECT ENAME, JOB, SAL, DNAME, LOC FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO AND SAL>=2000;
    -- EX2. DEPTNO 20 직원만 ENAME, DEPTNO, LOC
        SELECT ENAME, D.DEPTNO, LOC FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO AND D.DEPTNO=20;
    -- EX3. LOC=CHICAGO인 직원의 ENAME, SAL, DEPTNO
        SELECT ENAME, SAL, D.DEPTNO FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO AND LOC='CHICAGO';
    -- EX4. JOB='SALESMAN' OR 'MANAGER' 사원의 ENAME, SAL, COMM, ANNUAL, DNAME
        -- ANNUAL 정렬 DESC. ANNUAL = (SAL+COMM)*12
        SELECT ENAME, SAL, COMM, SAL+NVL(COMM,0)*12 ANNUAL, DNAME 
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND JOB IN ('SALESMAN', 'MANAGER')
            ORDER BY ANNUAL DESC;
    -- EX5. COMM=NULL, SAL>=1200 사원의 ENAME, SAL, DEPTNO, DNAME
        -- DNAME ASCE, SAL DESC 정렬
        SELECT ENAME, SAL, D.DEPTNO, DNAME
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND COMM IS NULL AND SAL>=1200
            ORDER BY DNAME, SAL DESC;

    -- 1.Q. 탄탄다지기 예제 EQUI JOIN 
        -- Q1. 뉴욕에서 근무하는 사원의 이름과 급여를 출력하시오
            SELECT ENAME, SAL 
                FROM EMP E, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND LOC='NEW YORK';
        -- Q2. ACCOUNTING 부서 소속 사원의 이름과 입사일을 출력하시오
            SELECT ENAME, HIREDATE 
                FROM EMP E, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND DNAME='ACCOUNTING';        
        -- Q3. 직급이 MANAGER인 사원의 이름, 부서명을 출력하시오
            SELECT ENAME, DNAME 
                FROM EMP E, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND JOB='MANAGER';
        -- Q4. Comm이 null이 아닌 사원의 이름, 급여, 부서코드, 근무지를 출력하시오.
            SELECT ENAME, SAL, D.DEPTNO, LOC 
                FROM EMP E, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;

            
-- 2. NON-EQUI JOIN : 동일한 컬럼 없이 다른 조건을 사용하여 조인
    SELECT * FROM EMP WHERE ENAME='SCOTT';
    SELECT * FROM SALGRADE;
    SELECT * FROM EMP, SALGRADE WHERE ENAME='SCOTT' AND SAL BETWEEN LOSAL AND HISAL; -- 범위 매칭
    -- EX1. 모든 사원의 사번, 이름, 급여, 급여등급(1등급, 2등급 ...), 상사사번
        SELECT EMPNO 사번, ENAME 이름, SAL 급여, GRADE||'등급' 급여등급, MGR 상사사번
            FROM EMP, SALGRADE 
            WHERE SAL BETWEEN LOSAL AND HISAL;
            
    --2.Q. 탄탄다지기 예제 NON-EQUI JOIN 
        -- Q1. Comm이 null이 아닌 사원의 이름, 급여, 등급, 부서번호, 부서이름, 근무지를 출력하시오.
            SELECT ENAME, SAL, GRADE, D.DEPTNO, DNAME, LOC 
                FROM EMP E, SALGRADE S, DEPT D 
                WHERE COMM IS NOT NULL AND SAL BETWEEN LOSAL AND HISAL;
        -- Q2. 이름, 급여, 입사일, 급여등급
            SELECT ENAME, SAL, HIREDATE, GRADE 
                FROM EMP E, SALGRADE S 
                WHERE SAL BETWEEN LOSAL AND HISAL;
        -- Q3. 이름, 급여, 급여등급, 연봉, 부서명을 부서명순으로 정렬하여 출력. 부서가 같으면 연봉순. 연봉=(sal+comm)*12 comm이 null이면 0
            SELECT ENAME, SAL, GRADE, (SAL+NVL(COMM,0))*12 ANNUAL, DNAME 
                FROM EMP E, SALGRADE S, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                ORDER BY DNAME, ANNUAL DESC;
        -- Q4. 이름, 업무, 급여, 등급, 부서코드, 부서명 출력. 급여가 1000~3000사이. 정렬조건 : 부서별, 부서같으면 업무별, 업무같으면 급여 큰순
            SELECT ENAME, JOB, SAL, GRADE, D.DEPTNO, DNAME 
                FROM EMP E, SALGRADE S, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL AND SAL BETWEEN 1000 AND 3000
                ORDER BY DNAME, JOB, SAL DESC;
        -- Q5. 이름, 급여, 등급, 입사일, 근무지. 81년에 입사한 사람. 등급 큰순
            SELECT ENAME, SAL, GRADE, HIREDATE, LOC
                FROM EMP E, SALGRADE S, DEPT D 
                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL AND TO_CHAR(HIREDATE, 'RR') = '81'
                ORDER BY GRADE DESC;

---- CH3 총 연습문제 PART.1
    --1. 모든 사원에 대한 이름, 부서번호, 부서명을 출력하는 SELECT 문장을 작성하여라.
        SELECT ENAME, D.DEPTNO, DNAME
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO;
    --2. NEW YORK에서 근무하고 있는 사원에 대하여 이름, 업무, 급여, 부서명을 출력
        SELECT ENAME, JOB, SAL, D.DEPTNO
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND LOC='NEW YORK';
    --3. 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력
        SELECT ENAME, DNAME, LOC
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND COMM>0; -- NULL이 알아서 걸러짐.
            -- WHERE E.DEPTNO=D.DEPTNO AND NOT (COMM IS NULL OR COMM = 0); 위가 훨씬 심플
    --4. 이름 중 L자가 있는 사원에 대하여 이름,업무,부서명,위치를 출력
        SELECT ENAME, JOB, DNAME, LOC
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND ENAME LIKE '%L%';
    --5. 사번, 사원명, 부서코드, 부서명을 검색하라(단, 사원명기준으로 오름차순 정렬)
        SELECT EMPNO, ENAME, D.DEPTNO, DNAME
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO
            ORDER BY ENAME;
    --6. 사번, 사원명, 급여, 부서명을 검색하라. 단 급여가 2000이상인 사원에 대하여 급여를 기준으로 내림차순으로 정렬하시오
        SELECT EMPNO, ENAME, SAL, DNAME
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND SAL >= 2000
            ORDER BY SAL DESC;
    --7. 사번, 사원명, 업무, 급여, 부서명을 검색하시오. 단 업무가 MANAGER이며 급여가 2500이상인 사원에 대하여 사번을 기준으로 오름차순으로 정렬하시오.
        SELECT EMPNO, ENAME, JOB, SAL, DNAME
            FROM EMP E, DEPT D
            WHERE E.DEPTNO=D.DEPTNO AND JOB = 'MANAGER' AND SAL >=2500
            ORDER BY EMPNO;
    --8. 사번, 사원명, 업무, 급여, 등급을 검색하시오(단, 급여기준 내림차순으로 정렬)
        SELECT EMPNO, ENAME, JOB, SAL, GRADE
            FROM EMP E, DEPT D, SALGRADE
            WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
            ORDER BY SAL DESC;
            
            
-- 3. SELF JOIN
    SELECT EMPNO, ENAME, MGR FROM EMP WHERE ENAME = 'SMITH';    -- A
    SELECT EMPNO, ENAME FROM EMP WHERE EMPNO = 7902;            -- B
    -- 스미스 상사 구하기 (AxB)
    SELECT WORKER.EMPNO, WORKER.ENAME, WORKER.MGR, MANAGER.ENAME MANAGER
        FROM EMP WORKER, EMP MANAGER
        WHERE WORKER.MGR = MANAGER.EMPNO AND WORKER.ENAME = 'SMITH';
    -- EX1. (상사가 있는) 모든 사원의 사번, 이름, 상사사번, 상사이름
        -- king은 mgr이 없다!
        SELECT E.EMPNO, E.ENAME, E.MGR MGRNO, M.ENAME MNAME
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO;
    -- EX2. 'SMITH의 상사는 FORD다' 포맷으로 출력
        SELECT E.ENAME || '의 상사는 ' || M.ENAME || '(이)다.' DESCRIPTION
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO;

    -- 3.Q. 탄탄다지기 예제 SELF-JOIN 
        -- Q. 매니저가 KING인 사원들의 이름과 직급
            SELECT E.ENAME, E.JOB
                FROM EMP E, EMP M
                WHERE E.MGR = M.EMPNO AND M.ENAME = 'KING';
            -- 확인하기
                SELECT EMPNO FROM EMP WHERE ENAME = 'KING'; -- KING 사번 7839 확인.
                SELECT ENAME FROM EMP WHERE MGR = 7839; -- 상사 사번 7839 3명 확인.
    
-- 4. OUTER JOIN : EQUI/SELF JOIN 시 조건에 만족하지 않은 행까지 적용
    -- 4.1. SELF JOIN에서의 OUTER JOIN
        SELECT E.ENAME, E.MGR, M.EMPNO MGRNO, M.ENAME MNAME
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO(+); -- NULL이 없는 쪽, '정보가 부족한 컬럼' 쪽에 (+)
        -- EX1. 'SMITH의 상사는 FORD다' / 'KING의 상사는 없다.'
            SELECT E.ENAME || '의 상사는 ' || NVL(M.ENAME, '없') || '다.'
                FROM EMP E, EMP M
                WHERE E.MGR = M.EMPNO(+);
        -- EX2. 말단 사원들
            SELECT M.*
                FROM EMP E, EMP M
                WHERE E.MGR(+) = M.EMPNO AND E.ENAME IS NULL; -- E.ENAME이 없는 M.ENAME들. 즉, 부하가 없어!
    -- 4.2. EQUI JOIN에서의 OUTER JOIN
        SELECT * FROM EMP; -- 14행
        SELECT * FROM DEPT; -- 4행
        SELECT * FROM EMP E, DEPT D 
            WHERE E.DEPTNO(+) = D.DEPTNO; -- DEPTNO.40, OPERATIONS BOSTON 부서 사원이 없다!
            

---- CH3 총 연습문제 PART.2
    -- 1. 이름, 직속상사명
        SELECT E.ENAME, M.ENAME MNAME
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO;
    -- 2. 이름, 급여, 업무, 직속상사명
        SELECT E.ENAME, E.SAL, E.JOB, M.ENAME MNAME
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO;
    -- 3. 이름, 급여, 업무, 직속상사명 . (상사가 없는 직원까지 전체 직원 다 출력. 상사가 없을 시 '없음'으로 출력)
        SELECT E.ENAME, E.SAL, E.JOB, NVL(M.ENAME, '없음') MNAME
            FROM EMP E, EMP M
            WHERE E.MGR = M.EMPNO(+);
    -- 4. 이름, 급여, 부서명, 직속상사명
        SELECT E.ENAME, E.SAL, D.DNAME, M.ENAME MNAME
            FROM EMP E, EMP M, DEPT D
            WHERE E.MGR = M.EMPNO AND E.DEPTNO = D.DEPTNO;
    -- 5. 상사가 없는 직원과 상사가 있는 직원 모두에 대해 이름, 급여, 부서코드, 부서명, 근무지, 직속상사명을 출력하시오(단, 직속상사가 없을 경우 직속상사명에는 ‘없음’으로 대신 출력하시오)
        SELECT E.ENAME, E.SAL, E.DEPTNO, D.DNAME, D.LOC, NVL(M.ENAME, '없음') MNAME
            FROM EMP E, EMP M, DEPT D
            WHERE E.MGR = M.EMPNO(+) AND E.DEPTNO = D.DEPTNO;
    -- 6. 이름, 급여, 등급, 부서명, 직속상사명. 급여가 2000이상인 사람
        -- SELECT * FROM SALGRADE;
        SELECT E.ENAME, E.SAL, S.GRADE, D.DNAME, M.ENAME MNAME
            FROM EMP E, EMP M, DEPT D, SALGRADE S
            WHERE E.MGR = M.EMPNO AND E.DEPTNO = D.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL AND E.SAL>=2000;
    -- 7. 이름, 급여, 등급, 부서명, 직속상사명, (직속상사가 없는 직원까지 전체직원 부서명 순 정렬)
        SELECT E.ENAME, E.SAL, S.GRADE, D.DNAME, M.ENAME MNAME
            FROM EMP E, EMP M, DEPT D, SALGRADE S
            WHERE E.MGR = M.EMPNO(+) AND E.DEPTNO = D.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL
            ORDER BY D.DNAME;
    -- 8. 이름, 급여, 등급, 부서명, 연봉, 직속상사명. 연봉=(SAL+COMM)*12으로 계산
        SELECT E.ENAME, E.SAL, S.GRADE, D.DNAME, M.ENAME MNAME, (E.SAL+NVL(E.COMM,0))*12 ANNUAL
            FROM EMP E, EMP M, DEPT D, SALGRADE S
            WHERE E.MGR = M.EMPNO(+) AND E.DEPTNO = D.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL;
    -- 9. 8번을 부서명 순 부서가 같으면 급여가 큰 순 정렬
        SELECT E.ENAME, E.SAL, S.GRADE, D.DNAME, M.ENAME MNAME, (E.SAL+NVL(E.COMM,0))*12 ANNUAL
            FROM EMP E, EMP M, DEPT D, SALGRADE S
            WHERE E.MGR = M.EMPNO(+) AND E.DEPTNO = D.DEPTNO AND E.SAL BETWEEN S.LOSAL AND S.HISAL
            ORDER BY D.DNAME, E.SAL DESC;
    -- 10. 사원명, 상사명, 상사의 상사명을 검색하시오(self join)
        SELECT E.ENAME, M.ENAME MNAME, B.ENAME BNAME
            FROM EMP E, EMP M, EMP B
            WHERE E.MGR = M.EMPNO AND M.MGR = B.EMPNO;
    -- 11. 위의 결과에서 상위 상사가 없는 모든 직원의 이름도 출력되도록 수정하시오(outer join)
        SELECT E.ENAME, M.ENAME MNAME, B.ENAME BNAME
            FROM EMP E, EMP M, EMP B
            WHERE E.MGR = M.EMPNO(+) AND M.MGR = B.EMPNO(+);