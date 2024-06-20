/*
    DML(DATA MANIPULATION LANGUAGE) : 데이터 조작 언어
    : 테이블에 값을 삽입(INSERT)하거나, 수정(UPDATE), 삭제(DELETE)하는 구문
*/

-------------------------------------------------------------------------------
/*
    INSERT
    : 테이블에 새로운 행을 추가하는 구문
    
    [표현식]
    1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3 ...);
        테이블의 모든 컬럼에 대한 값을 넣고자 할 때 (한 행 추가)
        컬럼의 순서를 지켜서 값을 넣어야 된다.
        
        값의 갯수가 부족하면 NOT ENOUGH VALUE 오류
        값의 갯수가 많으면 TOO MANY VALUES 오류
*/

SELECT * FROM employee;
INSERT INTO EMPLOYEE_COPY VALUES (300, '이말순', '030316-4123456', 'sun@naver.com', '01012345678', 'D7', 'J5', 3500000, 0.1, 200, SYSDATE, NULL, 'N');
-- EMPLOYEE에 데이터값 1부터 13까지 '순서대로' 넣어준 거임!

-------------------------------------------------------------------------------

/*

  2) INSERT INTO 테이블명(컬럼명, 컬럼명, ....) VALUES( 값1, 값2, ..);
    : 테이블에 내가 선택한 컬럼에만 값을 삽입할 때 사용
    → 내가 선택한 컬럼 값 이외의 값들을 NULL이 들어가고 DEFAULT 값이 설정 되어 있으면 DEFAULT 값이 들어간다.
    
    주의!!
    - 컬럼이 NOT NULL 제약 조건이 있으면 반드시 값을 넣어야 한다.
    - DEFAULT 값이 설정되어 있으면 안 넣어도 된다.
    
*/

INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE, PHONE)
VALUES('302', '이고잉', '120421-3456789', 'J5', sysdate, '01089780987');
-- INSERT INTO 구문에 있는 순서대로 써놓은 것!

INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE, PHONE)
VALUES('303', '우재남', '110711-4456780', 'J5', sysdate, '01089780985');
    
-- EMP_NO의 NULL값 오류
INSERT INTO EMPLOYEE_COPY(EMP_ID, EMP_NAME, HIRE_DATE, PHONE)
VALUES('304', '채규태', sysdate, '01089780985');

INSERT
    INTO EMPLOYEE_COPY
    (
        EMP_ID,
        EMP_NAME,
        EMP_NO,
        JOB_CODE,
        HERE_DATE,
        PHONE
        )
    VALUES
    (
        '302',
        '이고잉',
        '120421-3456789',
        'J5',
        sysdate,
        01089780987
        );
-- 한눈에 알아보기 쉽게 이렇게 쓰는 방법도 있다.

-------------------------------------------------------------------------------

/*

  3) INSERT INTO 테이블명 (서브쿼리);
  VALUES로 값을 직접 넣는 대신 서브쿼리로 조회된 결과를 모두 INSERT 가능

*/

CREATE TABLE EMP_01 (
    EMP_ID VARCHAR2(3),
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(35)
);

-- 전체 사원들의 사번, 사원명, 부서명 조회 (서브쿼리)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE_COPY, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- (+)를 하지않으면 NULL값인 사원들은 결과값에 나오지 않는다.

INSERT INTO EMP_01 (
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE_COPY, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+)
);


-------------------------------------------------------------------------------

/*

  4) INSERT ALL
     : 2개 이상의 테이블에 각각 INSERT할 때, 사용하는 서브쿼리가 동일한 경우
     
     [표현법]
     INSERT ALL
     INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
     INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
         서브쿼리;

*/

-- 테스트할 테이블 2개 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1=0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1=0;


-- 부서코드가 D1인 사원들의 사번, 이름, 부서 코드, 입사일, 사수사번 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
        FROM EMPLOYEE
        WHERE DEPT_CODE = 'D1';

-------------------------------------------------------------------------------

/*
    * 조건을 사용하는 INSERT ALL
    
    [표현법]
    INSERT ALL
    WHEN 조건1 THEN
         INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
    WHEN 조건2 THEN
         INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
    서브쿼리;
*/

-- 2000년도 이전에 입사한 사원들을 저장할 테이블 생성
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
-- 2000년도 이후에 입사한 사원들을 저장할 테이블 생성
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN 
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY --서브쿼리
FROM EMPLOYEE;


-------------------------------------------------------------------------------

/*
    * UPDATE
    테이블의 데이터를 수정하는 구문
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀 값,
        컬럼명 = 바꿀 값,
        ...
    [WHERE 조건]; → 주의 : 조건을 생략하면 모든 행의 데이터가 변경된다.    
    
*/

-- DEPARTMENT 복사본 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9 부서명을 전략 기획부로 변경!
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부';

ROLLBACK;


UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'
WHERE DEPT_ID ='D9';
    
    
-- EMPLOYEE_COPY 테이블에서 왕정보의 급여를 1,500,000으로 인상
UPDATE EMPLOYEE_COPY
SET SALARY = 1500000
WHERE EMP_NAME = '왕정보';

-- EMPLOYEE_COPY 테이블에서 구정하의 급여를 1,800,000으로 인상하고 보너스는 10%
UPDATE EMPLOYEE_COPY
SET SALARY = 1800000,
    BONUS = 0.1
WHERE EMP_NAME = '구정하';

-- EMPLOYEE_COPY 테이블에서 전체 사원의 급여가 기존의 급여에 10% 인상한 금액으로 변경
UPDATE EMPLOYEE_COPY
SET SALARY = SALARY * 1.1;
                   

-------------------------------------------------------------------------------

/*

    *서브 쿼리를 사용한 UPDATE
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    [WHERE 조건];
*/


-- 이고잉 사원의 급여와 보너스를 전정보 사원의 급여와 보너스 값으로 변경

--단일행 서브쿼리
UPDATE EMPLOYEE_COPY
SET SALARY = ( SELECT SALARY
               FROM EMPLOYEE_COPY
               WHERE EMP_NAME = '전정보' ),
    BONUS = ( SELECT BONUS
              FROM EMPLOYEE_COPY
              WHERE EMP_NAME = '전정보')
WHERE EMP_NAME = '이고잉';


--다중열 서브쿼리
UPDATE EMPLOYEE_COPY
SET (SALARY, BONUS) = ( SELECT SALARY, BONUS
                        FROM EMPLOYEE_COPY
                        WHERE EMP_NAME = '전정보' )
WHERE EMP_NAME = '이고잉';



-- 왕정보, 구정하, 선정보, 전지연, 장정보 사원의 급여와 보너스를 오정보 사원의 급여와 보너스 값으로 변경
UPDATE EMPLOYEE_COPY
SET ( SALARY, BONUS ) = ( SELECT SALARY, BONUS
                         FROM EMPLOYEE_COPY
                         WHERE EMP_NAME = '오정보' )
WHERE EMP_NAME IN ('왕정보', '구정하', '선정보','전지연', '장정보');

-- ASIA 지역에서 근무하는 사원들의 보너스 값을 0.3으로 변경 ( EMPLOYEE_COPY, DEPARTMENT, LOCATION )
UPDATE employee_copy
SET BONUS = 0.3
WHERE EMP_ID IN(SELECT EMP_ID
                FROM EMPLOYEE_COPY
                JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
                WHERE LOCAL_NAME LIKE 'ASIA%');

-- UPDATE시에도 제약조건에 위배되면 안된다.
-- 왕정보의 DEPT_CODE를 D0으로 변경
UPDATE EMPLOYEE_COPY
SET DEPT_CODE = 'D0'
WHERE EMP_NAME = '왕정보';
-- 오류 : 부모테이블에 D0이 없어서 제약조건 위배

UPDATE EMPLOYEE_COPY
SET DEPT_NO =  NULL
WHERE EMP_NAME = '왕정보';
-- 오류 : NOT NULL 제약조건 위배



-------------------------------------------------------------------------------

/*

    DELETE
    : 테이블의 데이터를 삭제하는 구문 (한 행 단위로 삭제)
    
    [표현식]
    DELETE FROM 테이블명
    [WHERE 조건]  → 주의 : 조건이 없으면 모든 데이터를 삭제한다.
*/

DELETE FROM EMPLOYEE_COPY;

ROLLBACK;

DELETE FROM EMPLOYEE_COPY
WHERE EMP_NAME = '왕정보';

DELETE FROM EMPLOYEE_COPY
WHERE DEPT_CODE = NULL;
/*

TRUNCATE : 테이블의 전체 행을 삭제할 때 사용하는 구문
           DELETE보다 수행속도가 빠르다
TRUNCATE TABLE 테이블명;

*/


TRUNCATE TABLE EMPLOYEE_COPY4;
ROLLBACK;
-- 롤백이 제대로 안댄다.













