/*
    *서브쿼리
    : 하나의 sql문안에 포함된 또 다른 select문
    - 메인 sql문을 위해 보조 역할을 하는 쿼리문
*/

-- 김정보와 같은 부서의 사원을 조회하시오.

-- ＃ 1. 김정보 부서 먼저 조회를 해야함!
select dept_code
from employee
where emp_name = '김정보';

-- ＃ 2. 부서가 D9인 사원 조회
SELECT EMP_NAME
 FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; 

-- ＃ 위의 단계를 하나의 쿼리문으로 합치기!

-- 방법 !! )  괄호 안에다가 1. 쿼리를 넣는다
select EMP_NAME
from employee
where DEPT_CODE = (select dept_code
                    from employee
                    where emp_name = '김정보');
 




-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 직급 코드, 급여조회

-- ＃ 1. 전 직원의 평균 급여
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- ＃ 2. 평균 급여보다 많이 받는 사원을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- WHERE SALARY > 평균급여
WHERE SALARY > (SELECT CEIL(AVG(SALARY))
                FROM EMPLOYEE);
                

--------------------------------------------------------------------------------
/*
    * 서브쿼리의 구분
        : 서브 쿼리를 수행한 결과값이 몇행 몇열이냐 따라 구분
        
    - 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열)
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일 때 (여러행 1열)
    - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러열 일 때 (1행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러열 일 때 (여러행 여러열)
    
    >> 서브쿼리의 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라진다.
    
*/

/*
    1. 단일행 서브 쿼리 : 서브쿼리의 조회 결과 값이 오로지 1개 일 때 ( 1행 1열 )
                        일반 비교 연산자 사용 가능
                        ( =, !=, >, < ... )
*/

-- 1) 전 직원의 평균 급여보다 더 적게 받는 직원의 사원명, 직급 코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
-- 적게 받는 사람들 :  WHERE SALARY < 평균
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
-- 2) 최저 급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE
                );

-- 3) 박정보 사원의 급여보다 더 많이 받는사원들의 사번, 사원명, 부서코드, 급여
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');
                
                
-- JOIN
-- 4) 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서명, 급여 조회

-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, department
WHERE DEPT_CODE = DEPT_ID
AND SALARY > (SELECT SALARY
              FROM EMPLOYEE
              WHERE EMP_NAME = '박정보');

-- >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '박정보');

-- 5) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회
     --   (단, 왕정보 제외)
-- >> 오라클 구문
SELECT EMP_ID, EMP_NAME,DEPT_CODE, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE , DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '왕정보')
AND EMP_NAME != '왕정보';

--> ANSI 구문
SELECT EMP_ID, EMP_NAME,DEPT_CODE, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '왕정보')      
 AND EMP_NAME != '왕정보'; 
 
 
 -- GROUP BY
 --6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
 --     6.1) 부서별 급여합 중 가장 큰 값 하나만 조회
 SELECT MAX(SUM(SALARY))
 FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
 -- 6.2) 부서별 급여합이 17700000인 부서를 조회
 SELECT DEPT_CODE, SUM(SALARY)
 FROM employee
 GROUP BY DEPT_CODE
 HAVING SUM(SALARY) = 17700000;
 
--6.1 + 6.2 위의 쿼리문을 하나로
 SELECT DEPT_CODE, SUM(SALARY)
 FROM employee
 GROUP BY DEPT_CODE
 HAVING SUM(SALARY) = ( SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                        GROUP BY DEPT_CODE);
 
 ------------------------------------------------------------------------------
 
/*
 2. 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 일 때 (여러행 1열)
  - IN 서브쿼리 : 여러개의 결과 값 중에서 한개라도 일치하는 값이 있다면 
  > ANY 서브쿼리 : 여러개의 결과 값 중에서 "한개라도" 클 경우
                 (여러개의 결과 값 중에서 가장 작은값 보다 클 경우)
  < ANY 서브쿼리 : 여러개의 결과 값 중에서 "한개라도" 작을 경우
                 ( (여러개의 결과 값 중에서 가장 큰 값 보다 작을 경우))
  
  비교대상 > ANY (값1, 값2, 값3)
  비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/

--1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
--  1.1) 조정연 또는 전지연의 직급
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN('조정연','전지연');

-- 1.2) J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 1.1 + 1.2  위의 쿼리문을 한줄로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ( SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN('조정연','전지연'));

-- 사원 → 대리 → 과장
-- 2) 대리 직급임에도 불구하고 과장 직급 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조회

-- >> 오라클
-- 2.1) 과장 직급의 사원들의 급여를 확인해봐야함
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장';

-- 2.2) 직급이 대리이면서 급여가 위의 목록의 값보다 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME ='대리'
AND SALARY > ANY(2200000, 2500000, 3760000);

-- 2.1 + 2.2 위의 쿼리문을 하나로!
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME ='대리'
AND SALARY > ANY (SELECT SALARY
                  FROM EMPLOYEE
                  JOIN JOB USING (JOB_CODE)
                  WHERE JOB_NAME = '과장');
                  
 ------------------------------------------------------------------------------
 
/*
    4. 다중열 서브쿼리
    : 결과값이 한행이고 컬럼 수가 여러 개일 때
*/

--1. (장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사람들)의 사원명, 부서코드, 직급코드, 입사일 조회

--1.1) 장정보 사원의 부서코드와 직급코드를 가져와야함.
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '장정보';

--1.2) 같은 직급코드에 해당하는 사람들의 사원명, 부서코드, 직급코드, 입사일 조회
/*
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 장정보의 부서코드 // 단일행 서브쿼리
AND JOB_CODE = 장정보의 직급코드 // 단일행 서브쿼리
*/
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '장정보')
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '장정보');

--1.3) 위에걸 요약한건!? ) 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE,JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                              FROM EMPLOYEE
                              WHERE EMP_NAME = '장정보');
                              
                              
                              
-- (지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는) 사원들의 사번, 사원명, 직급코드, 사수번호 조회

SELECT EMP_ID,EMP_NAME, DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
                                 FROM EMPLOYEE
                                 WHERE EMP_NAME = '지정보');
                                 
 ------------------------------------------------------------------------------
 
/* 
 4. 다중행 다중열 서브쿼리
 : 결과값이 여러 행이고 컬럼수가 여러 개 일때
 */
 
 --1) (각 직급별 최소 급여 금액을 받는 사원)의 사번, 사원명, 직급코드, 급여조회
 
 --1.1) 각 직급별 최소 급여
 SELECT JOB_CODE, MIN(SALARY)
 FROM EMPLOYEE
 GROUP BY JOB_CODE;
 
 /*
 이렇게 쓰는걸 줄이려면 어떻게 해야할까?
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
 GROUP BY JOB_CODE = 'J1' AND SALARY = 8000000
 OR JOB_CODE = 'J2' AND SALARY = 3700000
 ...
 */
  /*
 이렇게 쓰는걸 줄이려면 어떻게 해야할까?
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) = ('J1', 8000000)
    OR (JOB_CODE, SALARY) = ('J2', 3700000)
    OR (JOB_CODE, SALARY) = ('J3', 3700000)
 ...
 */

-- 서브쿼리
 SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
 FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY)IN ( SELECT JOB_CODE, MIN(SALARY)
                              FROM EMPLOYEE
                              GROUP BY JOB_CODE );

 
 --2) (각 부서별 최고급여를 받는 사원들)의 사번, 사원명, 부서코드, 급여조회
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
 FROM EMPLOYEE
 WHERE (DEPT_CODE, SALARY)IN ( SELECT DEPT_CODE, MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE );
                              
 ------------------------------------------------------------------------------
 
/* 
    인라인뷰
    
    인라인 뷰 (INLINE VIEW)
    : 서브쿼리를 수행한 결과를 마치 테이블처럼 사용
      FROM절에 서브쿼리 작성
      
      - 주로 사용하는 예 : TOP-N 분석 ( 상위 몇위만 가져오기)
*/

-- 1) 사원들의 사번, 이름, 보너스를 포함한 연봉, 부서코드 조회
--(단, NULL값이 안나오게 하고, 보너스포함 연봉이 3000만원 이상인 사원들만 조회)

SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 AS 연봉 , DEPT_CODE
FROM EMPLOYEE 
WHERE (SALARY * NVL(1+BONUS,1))*12 >= 30000000;
-- WHERE절은 별칭 사용 불가능. WHY?) FROM → WHERE → SELECT 순서 

-- 별칭을 사용하려면 INLINE VIEW 를 사용하자
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
      FROM EMPLOYEE)
      WHERE 연봉 <= 300000000;

SELECT EMP_ID, EMP_NAME, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
      FROM EMPLOYEE)
      WHERE 연봉 <= 300000000;

/* 이건 왜 오류뜰까?
SELECT EMP_ID, EMP_NAME, 연봉, ★HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, (SALARY * NVL(1+BONUS,1))*12 연봉, DEPT_CODE
      FROM EMPLOYEE)
      WHERE 연봉 <= 300000000;
      ★ FROM절 뒤의 테이블에서 HIRE_DAYE란 컬럼이 없기때문에 오류가 뜬다
*/

-- TOP-N분석
-- 전 직원중 급여가 가장 높은 상위 5명만 조회하시오.
-- * ROWNUM : 오라클에서 제공해주는 컬럼 , 조회된 순서대로 1부터 순번을 부여해줌

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC; -- 순서) FROM → SELECT → ORDER

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 10
ORDER BY SALARY DESC;

-- ORDER BY를 한 후, ROWNUM 을 붙여줘야한다.
SELECT *
FROM (SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC); -- 급여의 순서대로 조회

SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
FROM (SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC)
      -- 급여가 가장 높은사람이 1위 순서대로 시작하는겨!
WHERE ROWNUM <= 5;
-- 5위 까지만 조회

-- 이거보다 더 줄이게 쓰려면?!

/* ROWNUM, * 은 오류 !!
SELECT ROWNUM, *
FROM (SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;
*/
-- 오류를 풀려면?
SELECT ROWNUM, E.*
FROM (SELECT ROWNUM, EMP_ID, EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회

-- 1) 
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC);

-- 2)
SELECT ROWNUM, EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- 각 부서별 평균 급여가 높은 3개 부서의 부서코드, 평균급여(올림 사용)조회
SELECT *
FROM ( SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
       FROM EMPLOYEE
       GROUP BY DEPT_CODE
       ORDER BY 평균급여 DESC )
WHERE ROWNUM <= 3;

 ------------------------------------------------------------------------------
 
/* 
* WITH
  :서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
  
  -장점
  같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있고, 실행속도가 빠르다
  
  */
  
WITH TOPN_SAL AS (  SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE
                    ORDER BY 평균급여 DESC )
SELECT *
FROM TOPN_SAL
WHERE ROWNUM <= 3;

-- 실행 시 세미코론이 붙으면 그 테이블을 사용할 수가 없다..!
-- UNION, MINUS << 이런 식으로 FROM절에 2번이 쓸 때 가능
SELECT *
FROM TOPN_SAL
WHERE ROWNUM <= 5;

 ------------------------------------------------------------------------------
 
/* 
    * 순위 매기는 함수 (WINDOW FUNCTION)
    RANK() OVER(정렬기준) | DENSE_RANK() OVER (정렬기준)
    - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                             EX) 공동 1위가 2명이면 그 다음 순위는 3위
    - DENSE_RANK() OVER (정렬기준) : 동일한 순위 이후 그 다음 순위
                             EX) 공동 1위가 2명이면 그 다음 순위는 2위
*/

-- 급여가 높은 순서대로 순위를 메겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

-- 급여가 상위 5위인 사람의 사원명, 급여, 순위 조회
/*
오류) 윈도우 함수는 WHERE절을 쓸 수 없다!
SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5;
*/

-- SELECT절에서만 가능하다!
-- 어떻게? 인라인뷰를 사용해서!
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC)순위
      FROM EMPLOYEE)
WHERE 순위 <= 5;

-- WITH와 같이 사용
WITH ROPN_SALARY AS(SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC)순위
                    FROM EMPLOYEE)
SELECT *
FROM ROPN_SALARY
WHERE 순위 <=5;

-- 문제
-- 1. 2020년 12월 25일의 요일 조회
SELECT TO_CHAR(TO_DATE('20201225','YYYYMMDD'), 'DAY')
FROM DUAL;

-- 2. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 2) BETWEEN '70' AND '79'
AND SUBSTR(EMP_NO, 8, 1) = '2'
AND EMP_NAME LIKE '전%';

-- 3. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회

-- ANIS 구문
SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) AS 나이
,DEPT_TITLE, JOB_NAME
FROM employee
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE  EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) = 
(SELECT MIN( EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')))) FROM EMPLOYEE);


-- INLINE VIEW 구문
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) AS 나이
,DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)) E
WHERE E.나이 = (SELECT MIN( EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')))) FROM EMPLOYEE);


-- WITH 구문
WITH E AS(SELECT EMP_ID, EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) AS 나이
,DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE))
SELECT *
FROM E
WHERE 나이 = (SELECT MIN(나이) FROM E);


-- 4. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE EMP_NAME LIKE '%하%';

-- 5. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN department ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE DEPT_CODE IN ( 'D5', 'D6' );

-- 6. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN department ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;


-- 7. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
SELECT EMP_NAME ,JOB_NAME , DEPT_TITLE , LOCAL_NAME 
FROM EMPLOYEE
JOIN department ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN JOB USING(JOB_CODE);


-- 8. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN department ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_CODE IN ( 'KO', 'JP' );

-- 9. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
SELECT EMP_NAME,DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = ( SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '하정연');

-- 10. (보너스가 없고 직급 코드가 J4이거나 J7인 사원)의 사원명, 직급명, 급여 조회 (NVL 이용)
SELECT EMP_NAME, JOB_NAME, SALARY, NVL(BONUS, 0) 보너스
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_CODE IN ( 'J4', 'J7' );
-- 이거 한번 질문하기  NVL(BONUS, '보너스 없음') 은 왜 오류뜨는지


-- 11. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
SELECT COUNT(EMP_NAME), ENT_YN
FROM EMPLOYEE
GROUP BY ENT_YN;

-- 12. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
SELECT *
FROM(SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 
RANK() OVER(ORDER BY (SALARY*NVL(1+BONUS,1)*12)DESC) 순위
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE))
WHERE 순위 <= 5;
      

-- 13. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	13-1. JOIN과 HAVING 사용
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID )
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
                     FROM EMPLOYEE);
           
--	13-2. 인라인 뷰 사용
SELECT *
FROM ( SELECT DEPT_TITLE, SUM(SALARY) "부서별 급여 합"
       FROM EMPLOYEE
       JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID )
       GROUP BY DEPT_TITLE)
WHERE "부서별 합" > (SELECT SUM(SALARY)*0.2
                    FROM EMPLOYEE);

--	13-3. WITH 사용
WITH TOTAL_SAL AS (SELECT DEPT_TITLE, SUM(SALARY) "부서별 급여 합"
                   FROM EMPLOYEE
                   JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID )
                   GROUP BY DEPT_TITLE)
SELECT *
FROM TOTAL_SAL
WHERE "부서별 합" > (SELECT SUM(SALARY)*0.2
                    FROM EMPLOYEE);

-- 14. 부서명별 급여 합계 조회(NULL도 조회되도록)

--ANSI 구문
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE;

-- 오라클 전용 구문
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+)
GROUP BY DEPT_TITLE;


-- 15. WITH를 이용하여 급여합과 급여평균 조회
WITH SUM_SAL AS (SELECT SUM(SALARY) FROM EMPLOYEE),
     AVG_SAL AS (SELECT CEIL(AVG(SALARY)) FROM EMPLOYEE)
/*
이렇게하면 따로따로 나온다 
SELECT *
FROM SIM_SAL
UNION
SELECT *
FROM AVG_SAL;
*/

SELECT *
FROM SUM_SAL, AVG_SAL;
-- 이렇게하면 열로나오고

