-- 한줄 주석 ♡ (단축 키 : ctrl + /)

/*
   여러줄 주석 ♡ (단축 키 : alt + shift + c)
*/

-- 커서(마우스)가 있는 줄 실행 단축키 : crtl + enter

-- 나의 계정 보기
show user;

-- 사용자 계정 조회
/*
    조회시 select ~ from 이 기본 구문이다.
    select (속성명) from (테이블명)
*/
select * from dba_users;
select username, user_id from dba_users;
-- username과 user_id를 dba_users로부터 가져와! 라는 뜻

/*
    * 내가 사용할 user를 계정 생성
      오라클 12버전부터 일반 사용자는 C##로 시작하는 이름을 가져야 함
      비밀번호는 문자로만 가능 
*/
-- CREATE USER user1 IDENTIFIED BY 1234;
CREATE USER c##user2 IDENTIFIED BY 1234;

-- c## 키워드를 회피하는 설정
alter session set "_oracle_script" = true;

-- 수업시간에 사용할 user생성
/*
    계정명은 대소문자를 안가린다
    기본구문 : create user 계정명 identified by 비밀번호
*/
create user tjoeun identified by 1234;

--권한 생성
/*
    (표현법) GRANT 권한1, 권한2, ... , TO 계정명;
*/

GRANT RESOURCE, CONNECT TO tjoeun;

-- USER 삭제
-- 기본 구문 : DROP USER USER명 CASDCAED

-- insert시 생성된 유저에게 테이블스페이스에 얼마만큼의 영역을 할당할 것인지를 정해줘야 한다.
alter user tjoeun default tablespace users quota unlimited on users;

-- 특정 용량만큼 정해서 할당
alter user tjoeun quota 30M on users;


--춘대학교 사용자 만들기
alter session set "_oracle_script" = true;
create user chun identified by 1234;
GRANT RESOURCE, CONNECT TO chun;
alter user chun default tablespace users quota unlimited on users;

--DDL 사용자 만들기
alter session set "_oracle_script" = true;
create user DDL identified by 1234;
GRANT RESOURCE, CONNECT TO DDL;
alter user DDL default tablespace users quota unlimited on users;

--JSP 사용자 만들기
alter session set "_oracle_script" = true;
create user JSP identified by 1234;
GRANT RESOURCE, CONNECT TO JSP;
alter user JSP default tablespace users quota unlimited on users;

--MYBATIS 사용자 만들기
alter session set "_oracle_script" = true;
create user MYBATIS identified by 1234;
GRANT RESOURCE, CONNECT TO MYBATIS;
alter user MYBATIS default tablespace users quota unlimited on users;

--SPRINGBOOT 사용자 만들기
alter session set "_oracle_script" = true;
create user springboot identified by 1234;
GRANT RESOURCE, CONNECT TO springboot;
alter user springboot default tablespace users quota unlimited on users;

--project ECR 사용자 만들기
alter session set "_oracle_script" = true;
create user ECR identified by 1234;
GRANT RESOURCE, CONNECT TO ECR;
alter user ECR default tablespace users quota unlimited on users;

--project ECR 사용자 만들기
alter session set "_oracle_script" = true;
create user dicom identified by 1234;
GRANT RESOURCE, CONNECT TO dicom;
alter user dicom default tablespace users quota unlimited on users;

