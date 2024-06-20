/*
    TCL (TRANSACTION CONTROL LANGUAGE)
    : 트랜잭션 제어 언어
    
    * 트랜잭션
    - 데이터베이스의 논리적 연산단위
    - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
      DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션이 같이 묶어서 처리
                           트랜잭션이 존재하지 않으면 트랜잭션이 만들어서 묶어서 처리
    
      COMMIT 하기 전까지의 변경사항들을 하나의 트랙잭션에 담아둔다.
    - 트랜잭션의 대상이 되는 SQL문 : INSERT, UPDATE, DELETE
    
      COMMIT(트랜잭션 종료 처리후 확정)
      ROLLBACK (트랜잭션 취소)
      SAVEPOINT (임시저장)
      
    - COMMIT : 한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미 ( 이후에 트랜잭션은 사라진다 )
    - ROLLBACK : 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT 시점으로 돌아간다.
    - SAVEPOINT : 현재 이 시점에 해당 포인명으로 임시저장점을 정의해 두는 것
                  ROLLBACK 진행 시 전체 변경사항을 삭제하는 것이 아니라 일부만 삭제
    
*/

SELECT * FROM EMP_01;

-- 사번이 303번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 303;
-- 실질적 DB는 삭제가 되어있지 않고 트랜잭션에 쌓인다.

-- 사번이 302번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 302;

ROLLBACK;

---------------

-- 사번이 214번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 214;

SELECT * FROM EMP_01;

INSERT INTO EMP_01
VALUES(500, '김미영', '인사관리부');
-- DB에 들어가진 않고 트랜잭션에 들어가져 있는 것이다.

COMMIT;
-- 트랜잭션에 들어가있는 것을 DB에 들어가게 하는 것!

---------------

--사번이 200, 201, 202번인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN(200,201,202);

--임시저장 지점
SAVEPOINT SP;

INSERT INTO EMP_01
VALUES(501, '이세종', '총무부');

DELETE FROM EMP_01
WHERE EMP_ID = 220;

ROLLBACK TO SP; -- 임시 저장점 까지만 ROLLBACK 하시오

SELECT * FROM EMP_01 ORDER BY EMP_ID;

COMMIT;

--------------------------------------------------------------------------------
/*
    자동 COMMIT이 되는 경우
    - 정상 종료
    - DCL과 DDL문이 수행된 경우
    
    자동 ROLLBACK이 되는 경우
    - 비정상 종료
    - 전원이 꺼짐 (컴퓨터 DOWN)
*/

-- 303번 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = 303;

-- 500번 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID 500;

CREATE TABLE TEST(
    TID NUMBER
    );
    -- 테이블을 생성하면 트랜잭션에있는 303번, 500번이 DB에 들어간다.
    -- DDL 구문을 실행하는 순간 COMMIT이 된다
    
ROLLBACK;
-- COMMIT이 되었기 때문에 ROLLBACK이 되지 않는다.













