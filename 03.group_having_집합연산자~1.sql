/*
    * GROUP BY절
    그룹기준을 제시할 수 있는 구문 (해당 그룹별로 여러 그룹으로 묶을 수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/

SELECT SUM(SALARY)
FROM EMPLOYEE; -- 전체 사원을 하나의 그룹으로 묶어서 총합을 구한 결과

-- 각 부서별 급여의 합계
SELECT DEPT_CODE, SUM(SALARY) -- 그룹별로의 합계
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원의 수
SELECT DEPT_CODE, COUNT(*)
FROM employee
GROUP BY DEPT_CODE;

SELECT DEPT_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1; --첫번째를 기준으로 오름차순 정렬


-- 각 직급별 직원의 수와 급여의 합계 조회
SELECT JOB_CODE, COUNT(*), SUM(SALARY)
FROM employee
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 직원의 수, 보너스를 받는 사원수, 급여 합, 평균급여, 최저급여, 최고급여
SELECT JOB_CODE, COUNT(BONUS), COUNT(SALARY), CEIL(AVG(SALARY)), MIN(SALARY), MAX(SALARY)
FROM employee
GROUP BY JOB_CODE
ORDER BY 1;

-- ORDER BY 함수식 사용가능
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, COUNT(*) 인원수
FROM employee
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- ORDER BY절에 여러 컬럼 기술
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM employee
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;


--------------------------------------------------------------------------------
/*
    * HAVING 절 : 그룹에 대한 조건을 제시할 때 사용
                 ( 주로 그룹 함수식을 가지고 조건식을 제시할 때 사용한다 )
*/

-- 각 부서별 평균 급여 조회
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균 급여가 3백만원 이상인 부서들만 조회
/* 그룹 함수에는 WHERE절 불가능. (조건문 불가능)
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000
GROUP BY SALARY;
*/
-- 그룹에다가 조건을 두려면 HAVING을 써야한다
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

-- 문제
--1. 직급별 총 급여합 (단, 직급별 급여합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;


/*
    SELECT문 실행 순서
    1. FROM
    2. ON
    3. JOIN
    4. WHERE
    5. GROUP BY
    6. HAVING
    7. SELECT
    8. DISTINCT
    9. ORDER BY
*/
--------------------------------------------------------------------------------

/*
    집계 함수 : 그룹별 산출된 결과 값에 중간집계를 계산해주는 함수
    
    ROLLUP / CUBE → GROUP BY절에 기술
    - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중계집계를 내는 함수
    - CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중계집계를 내고, 컬럼2를 가지고도 중간집계를 낸다.
*/

--각 직급별 급여함
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE; -- 컬럼이 1개일 때 써도 되지만 의미가 없다.

--DEPT_CODE, JOB_CODE 쌍으로 집계를 낼때

--ROLLUP
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

--CUBE
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;


--==============================================================================
--                             집합 함수
--==============================================================================
/*
    * 집합 연산자 = SET OPERATION
      여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
      
    - UNION : OR | 합집합( 두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한 번만 조회 )
    - INTERSECT : AND | 교집합( 두 쿼리문을 수행한 결과값에 중복된 결과 값)
    - UNION ALL : 차집합(선행결과값에서 후행결과값을 뺀 나머지)
*/

-- 1. UNION
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- OR
SELECT MEP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 30000000;


-- 2. INTERSECT
-- 부서코드가 D5인 사원 급여가 300만원 초과인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
--각 쿼리문의 SELECT 절에 작성되는 컬럼의 갯수는 동일해야한다.


--AND
SELECT MEP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 30000000;

-- 3. UNION ALL
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들을 모두 조회(중복은 중복된 갯수만큼 조회)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- 4. MINUS
-- 부서코드가 D5인 사원들 중 급여가 300만원 초과인 사원들을 제거하고 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' AND SALARY <= 3000000;





