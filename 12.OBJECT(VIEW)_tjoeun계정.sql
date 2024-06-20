/*
VIEW
 : SELECT문을 저장해줄 수 있는 객체
   (자주 쓰이는 긴 SELECT문을 저장해 두엇다가 호출하여 사용할 수 있다.)
   임시테이블 같은 존재(실제 데이터가 담겨있는거 아님 → 논리적 테이블)
*/

-- 한국에서 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_ID = DEPT_CODE )
JOIN LOCATION ON ( LOCAL_CODE = LOCATION_ID )
JOIN NATIONAL USING ( NATIONAL_CODE )
WHERE NATIONAL_NAME = '한국';


-- 러시아 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_ID = DEPT_CODE )
JOIN LOCATION ON ( LOCAL_CODE = LOCATION_ID )
JOIN NATIONAL USING ( NATIONAL_CODE )
WHERE NATIONAL_NAME = '러시아';


-- 일본 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_ID = DEPT_CODE )
JOIN LOCATION ON ( LOCAL_CODE = LOCATION_ID )
JOIN NATIONAL USING ( NATIONAL_CODE )
WHERE NATIONAL_NAME = '일본';


-- 똑같은걸 계속 쓸때 !! 이럴때 VIEW를 쓴다  


------------------------------------------------------------------------------

/*
    1. VIEW 생성
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
*/
-- 관리자 계정으로 권한을 부여!
GRANT CREATE VIEW TO TJOEUN;

-- TJOEUN계정으로 다시 바꾼후 실행!

--VIEW 생성!
CREATE VIEW VM_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_ID = DEPT_CODE )
JOIN LOCATION ON ( LOCAL_CODE = LOCATION_ID )
JOIN NATIONAL USING ( NATIONAL_CODE );


SELECT * FROM VM_EMPLOYEE;

--한국에서 근무하는 사원 검색
SELECT *
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '한국';
-- 반복적인 구문을 쓰게 되면, VIEW를 쓰면 코드를 확 ! 줄일수 있다!!!

--일본에서 근무하는 사원 검색
SELECT *
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

--------------------------------------------------------------------------------

/*
    뷰 컬럼에 별칭 부여
    서브쿼리의 서브쿼리에 함수식, 산술식이 기술되면 반드시 별칭부여
*/

-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 뷰(VM_EMP_JOB) 생성
-- CREATE OR REPLACE VIEW : 이미 같은 이름의 뷰가 있으면 덮어쓰기 함, 없으면 그냥 생성

CREATE VIEW VM_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여'), EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING (JOB_CODE);
-- 오류 : 함수식이 들어간 컬럼에 별칭을 안했음!!

CREATE VIEW VM_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여') 성별, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
   FROM EMPLOYEE
   JOIN JOB USING (JOB_CODE);
-- 별칭을 반드시 부여해야함!


CREATE VIEW VM_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1),'1','남','2','여'), EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE
   JOIN JOB USING (JOB_CODE);
   -- 이렇게도 가능

--여성사원의 사원명, 근무년수 검색
SELECT 사원명, 근무년수
FROM VM_EMP_JOB
WHERE 성별 = '여';

-- 30년 이상 근무한 직원 사원명, 직급명 검색
SELECT 사원명, 직급명
FROM VM_EMP_JOB
WHERE 근무년수 >=30;


--------------------------------------------------------------------------------

/*

뷰삭제
DROP VIEW 뷰명

*/

DROP VIEW VM_EMP_JOB;

--------------------------------------------------------------------------------

/*

생성된 VIEW를 통해 DML사용 가능
VIEW에서 INSERT, UPDATE, DELETE를 실행하면 실제 데이터베이스에 반영된다.
 
*/

-- 뷰(VM_JOB) JOB 테이블의 모든 컬럼 서브쿼리
CREATE OR REPLACE VIEW VM_JOB
AS SELECT *
   FROM JOB;
   
-- 뷰에 한행 추가
INSERT INTO VM_JOB VALUES('JB','인턴');

SELECT * FROM JOB;
SELECT * FROM VM_JOB;

-- 뷰에 UPDATE
UPDATE VM_JOB
   SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 뷰에서 삭제
DELETE FROM VM_JOB
WHERE JOB_CODE = 'J8';

/*
    단, DML 명령어로 조작이 불가능한 경우가 더 많다
    1) 뷰에 정의되어 있지 않은 컬럼을 조작하고자 하는 경우
    2) 뷰의 정의되어 있는 컬럼 중에 원본테이블 상에 NOT NULL 제약 조건이 지정되어 있는 경우
    3) 산술식 함수식으로 정의 되어 있는 경우
    4) 그룹함수나 GROUP BY절이 포함되어 있는 경우
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우
    
*/

-- 1) 뷰에 정의되어 있지 않은 컬럼을 조작하고자 하는 경우
CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_CODE
   FROM JOB;
   
SELECT * FROM JOB;
SELECT * FROM VM_JOB;

--INSERT 오류
INSERT INTO VM_JOB(JOB_CODE, JOB_CODE, JOB_NAME) VALUES('J8','인턴');
-- VIEW에 없는거를 넣었기 때문에 오류가 뜬다.

-- UPDATE 오류
UPDATE VM_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';

--DELETE 오류
DELETE 
FROM VM_JOB
WHERE JOB_NAME = '사원';

-- 2) 뷰의 정의되어 있는 컬럼 중에 원본테이블 상에 NOT NULL 제약 조건이 지정되어 있는 경우
CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_NAME
    FROM JOB;
    
SELECT * FROM JOB;
SELECT * FROM VM_JOB;

--INSERT 오류
INSERT INTO VM_JOB VALUES('인턴');
-- 실제 원본테이블에는 (NULL, '인턴'); -- JOB_CODE는 NULL값 허용 안함

-- UPDATE 성공
UPDATE VM_JOB
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';

ROLLBACK;

-- DELETE 할 때 부모테이블을 VIEW로 만들었다면 외래키 제약 조건도 따져야한다.
-- 자식테이블에 쓰고 있는 데이터라면 삭제가 안된다.

--3) 산술식 함수식으로 정의 되어 있는 경우
CREATE OR REPLACE VIEW VM_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
FROM EMPLOYEE;

-- INSERT(오류) : 연봉은 원본테이블 없는 컬럼
INSERT INTO VM_EMP_SAL VALUES (300, '김상진', 30000000, 36000000);
   
-- UPDATE(오류) : 연봉은 원본테이블에 없는 컬럼
UPDATE VM_EMP_SAL
SET 연봉 = 2000000
WHERE EMP_ID = 214;

-- UPDATE(성공)
UPDATE VM_EMP_SAL
SET SALARY = 2000000
WHERE EMP_ID = 214;

ROLLBACK;

-- 4) 그룹함수나 GROUP BY절이 포함되어 있는 경우
CREATE OR REPLACE VIEW VM_GROUP_DEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, CEIL(AVG(SALARY)) 평균
-- 함수식썼으니 반드시 별칭 써야함
FROM EMPLOYEE
GROUP BY DEPT_CODE;

--INSERT
INSERT INTO VM_GROUP_DEPT VALUES('D3', 80000000, 40000000);

--UPDATE(오류)
UPDATE VM_GROUP_DEPT 
    SET 합계 = 90000000
WHERE DEPT_CODE = 'D1';

--DELETE(오류)
DELETE VM_GROUP_DEPT 
WHERE DEPT_CODE = 'D1';

--5)DISTINCT구문이 포함된 경우
CREATE OR REPLACE VIEW VM_JOB
AS SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

--INSERT(오류)
INSERT INTO VM_JOB VALUES('J8');

--UPDATE(오류)
UPDATE VM_JOB
    SET JOB_CODE = 'J8'
WHERE JOB_CODE = 'J1';

--DELETE(오류)
DELETE VM_JOB
WHERE JOB_CODE = 'D2';


-- 6) JOIN을 이용하여 여러 테이블을 연결시켜놓은 경우
CREATE OR REPLACE VIEW VM_JOIN
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- INSERT (오류)
INSERT INTO VM_JOIN VALUES(600,'황미연', '회계관리부');

-- UPDATE (성공)
UPDATE VM_JOIN 
SET EMP_NAME = '김새로'
WHERE EMP_ID = 201;

-- UPDATE (성공)
UPDATE VM_JOIN 
SET EMP_NAME = '인사관리부'
WHERE EMP_ID = 201;

-- DELETE (성공)
DELETE FROM VM_JOIN
WHERE EMP_ID = 200;

--------------------------------------------------------------------------------
/*
VIEW 옵션
CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
AS 서브쿼리
[WITH CHECK OPTION]
[WITH READ ONLY];

1) OR REPLACE : 기존에 동일한 뷰가 있다면 덮어쓰기, 없다면 새로 생성
2) FORCE | NOFORCE
  > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다
  > NOFORCE : 서브쿼리에 기술된 테이블이 실제 존재해야만 뷰가 생성된다. ( 생략시 기본값 )
3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML을 가능하도록 한다.
4) WITH READ ONLY : 뷰를 조회만 가능 (DML 수행불가)
*/

--2) FORCE | NOFORCE
-- NOFORCE
CREATE OR REPLACE NOFORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
FROM IT;

-- FROCE
CREATE OR REPLACE FORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
FROM IT;
-- 컴파일 오류는 뜨지만 뷰는 생성이 된다.

INSERT INTO VM_EMP VALUES(1, 'NAME', 'CONTMENT');
-- 실제 뷰를 사용하려면 IT라는 실존 테이블이 있어야 사용가능하다

CREATE TABLE IT (
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(100)
);

INSERT INTO VM_EMP VALUES(1, 'NAME', 'CONTMENT');
-- 테이블 생성시에는 생성 가능


--3) WITH CHECK OPTION
CREATE OR REPLACE VIEW VM_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;






