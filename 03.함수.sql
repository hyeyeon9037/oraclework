/*
    <함수 function>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    -단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환(매 행마다 실행)
    -그룹 함수 : N개의 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
    >> 함수식을 기술할 수 있는 위치 :  SELECT절, WHERE절, ORDER BY절, HAVING절
*/

---------------------------------단일행 함수-------------------------------------
--==============================================================================
--                               문자처리 함수
--==============================================================================
/*
    LENGTH / LENGTHB => NUMBER로 치환
    
    LENGTH(컬럼 | '문자열') : 해당 문자열의 글자수 반환
    LENGTHB(컬럼 | '문자열') : 해당 문자열의 byte수 반환
        - 한글 : XE 버전일 때 => 1글자당 3byte(ㄱ, ㅏ 등도 3byte)
                 E 버전일 때 => 1 글자당 2byte
        - 그외 : 1글자당 1byte
*/
SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; --오라클이 제공하는 가상 테이블

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아서 반환(반환형 : NUMBER)
        -ORACLE에서 INDEX번호는 1부터 시작, 찾을 문자가 없으면 0 반환
     
     [표현법]
     INSTR(컬럼 | '문자열', '찾고자하는 문자', [찾을 위치의 시작값, [순번]])
     
     - 찾을 위치 시작값
        1 : 앞에서부터 찾기(기본값)
        -1  : 뒤에서부터 찾기
*/
SELECT INSTR('JAVASCRIPTJAVAORACLE','A') FROM DUAL; 
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 1) FROM DUAL; 
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1) FROM DUAL; 
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 1, 3) FROM DUAL; -- 맨 앞에서부터 3번째에 나오는 A 찾으시오
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1,2) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 5) FROM DUAL; -- 인덱스 번호 5번부터 찾으시오 그래서 5번부터 찾았을 때 A가 나오는 인덱스 번호는 12

SELECT EMAIL, INSTR(EMAIL, '_') "_의 위치", INSTR(EMAIL, '@') "@의 위치"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    *SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : NUMBER)
    
    [표현법]
    SUBSTR(컬럼 | '문자열', POSITION, [LENGTH])
    - POSTION : 문자열을 추출할 시작위치 INDEX
    - LENGTH : 추출 할 문자의 갯수(생략시 마지막까지 추출)
*/
SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL; --7번부터 문자열 추출
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL; --7번부터 문자열 추출 근데 문자의 갯수를 4개만 추출
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL; --뒤에서부터 7번에서 갯수 4개 추출

--EMPLOYEE에서 주민번호에서 사원명, 주민번호, 성별(주민번호에서 성별만 추출하기)
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

--EMPLOYEE에서 여자사원들의 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME , SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

--EMPLOYEE에서 여자사원들의 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME , SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

--EMPLOYEE에서 남자 사원들의 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME , SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN (1,3)
-- IN을 사용하여 더 짧게 쓸수도 있다 !
ORDER BY 2;

-- ★ EMPLOYEE에서 사원명, 이메일, 아이디 조회
SELECT EMP_ID, EMAIL,SUBSTR(email, 1, INSTR(EMAIL, '@')-1 ) 아이디
FROM EMPLOYEE;


--------------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 ( O반환형 : CHARACTER )
    
    [표현법]
    
    - LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
    : 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
*/

-- EMPLOYEE에서 사원명, 이메일(길이 20, 오른쪽 정렬)
SELECT EMP_NAME, EMAIL, LPAD(EMAIL, 20) 
FROM EMPLOYEE;
-- 이거 정리할때 결과값도 같이 붙이고 이거 쓰자 -> 덧붙이고자하는 문자 생략시 공백으로 채워진다.

SELECT EMP_NAME, EMAIL, RPAD(EMAIL, 25, '#')
FROM EMPLOYEE;

-- EMPLOYEE에서 사번, 사원명, 주민번호(단, 123456-1******로 출력) 조회
SELECT EMP_ID, EMP_NAME,RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') 주민번호
FROM EMPLOYEE;

SELECT SUBSTR(EMP_NO, 1, 8)
FROM EMPLOYEE;
----------------------------------------------------------------------------------
/*
    * LTRIM/RTRIM : 문자열에서 특정문자를 제거한 나머지를 반환( 반환형 : CHARRACTER )
    * TRIM : 문자열에서 앞/뒤 양쪽에 있는 특정문자를 제거한 나머지를 반환
    - TRIM 주의사항 : 제거할 문자는 1글자만 가능하다.
    
    [표현법]
    LTRIM / RIRTM('문자열', [제거하고자하는 문자들])
    TRIM([LEADING | TRAILNG | BOTH]제거하고자하는 문자들 FROM '문자열')
        
    문자열의 왼쪽 또는 오른쪽으로 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열 반환
*/

SELECT LTRIM('     tjoeun     ')||'학원' FROM DUAL;
-- LTRTM 왼쪽 공백 제거

SELECT RTRIM('     tjoeun     ')||'학원' FROM DUAL;
-- RTRIM 오른쪽 공백 제거

-- 두개다 왜 공백을 제거하는가? → 제거하고자하는 문자를 넣지 않아서 공백이 제거가 됐음.


 -- 단어별로 사라지는게 아니라 하나하나 사라지는것 즉, 'J', 'A', 'V'를 본다는 것. 다른글자가 나오는순간 끝남.

-- 왼쪽 기준
SELECT LTRIM('JAAVAZZJAVASCRIPT', 'JAVA') FROM DUAL;
SELECT LTRIM('BACACABCFIACB', 'ABC') FROM DUAL;  -- 'A', 'B', 'C'
SELECT LTRIM('37284BAC38290', '0123456789') FROM DUAL; -- '0', '1', .. ,'9' 

-- 오른쪽 기준
SELECT RTRIM('BACACABCFIACB', 'ABC') FROM DUAL; 
SELECT RTRIM('37284BAC38290', '0123456789') FROM DUAL; 

-- 왼쪽 오른쪽 기준 (둘다)
-- BOTH가 기본값 : 양쪽 제거
SELECT TRIM('     tjoeun     ')||'학원' FROM DUAL;
SELECT TRIM('A' FROM 'AAABKSLEIDKAAA') FROM DUAL; 
-- SELECT TRIM('AB' FROM 'ABAABKSLEIDKAABBA') FROM DUAL; ★ TRIM 주의사항 !! 제거할 문자는 1글자만 가능 따라서 'AB' 불가능!

SELECT TRIM(LEADING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL; - 앞 a 제거
SELECT TRIM(TRAILING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL; - 뒤 a 제거

--------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
    
    [표현법]
    LOWER('문자열') - 소문자 변환
    UPPER('문자열') - 대문자 변환
    INITCAP('문자열') - 앞글자만 대문자로 변환
*/

SELECT LOWER('Java JavaScript Oracle') from dual;
SELECT UPPER('Java JavaScript Oracle') from dual;
SELECT INITCAP('java javaScript oracle') from dual;

SELECT EMAIL, UPPER(EMAIL)
FROM EMPLOYEE;


--------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 두개를 하나로 합친 후 반환
    
    [표현법]
    CONCAT('문자열', '문자열')
*/

SELECT CONCAT('Oracle', '오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL;
-- 둘다 똑같은 말

-- 오류가 뜨는 이유는 ? SELECT CONCAT('Oracle', '오라클', '02-1234-5678') FROM DUAL; 
-- 문자열을 3개 넣었기 때문.
-- 저렇게 하려면 SELECT 'Oracle' || '오라클' || '02-1234-5678' FROM DUAL; 써야함

--------------------------------------------------------------------------------
/*
    *REPLACE : 기존 문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열', '기존문자열', '바꿀문자열')
*/ 
SELECT REPLACE(email, 'tjoeun.or.kr', 'naver.com')
FROM EMPLOYEE;



--==============================================================================
--                               숫자처리 함수
--==============================================================================
/*
    * ABS : 숫자의 절대값을 구하는 함수
    
    [표현법]
    ABS(숫자)
*/

SELECT ABS(-5) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지 값을 반환하는 함수
    
    [표현법]
    MOD(숫자1, 숫자2)
    숫자1 ÷ 숫자2
*/

SELECT MOD(10, 3) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과 반환
    
    [표현법]
    ROUND(숫자, [위치])
*/

SELECT ROUND(1234.567) FROM DUAL;
-- 위치를 안 적으면 소숫점 뒷자리로 반올림을 함

SELECT ROUND(1234.567, 2) FROM DUAL;
SELECT ROUND(1234567, -2) FROM DUAL;
-- 뒷자리에서 2번쨀(6) 반올림 한후 0으로 바낌

--------------------------------------------------------------------------------
/*
    * CEIL : 올림한 결과 반환
    
    [표현법]
    CELL(숫자)
  
*/

SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(-123.4566) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * FLOOR : 내림한 결과 반환
    
    [표현법]
    FLOOR(숫자)
  
*/

SELECT FLOOR(123.987) FROM DUAL;
SELECT FLOOR(-123.987) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * TRUNC : 위치 지정 가능한 버림 처리 반환
    
    [표현법]
    TRUNC(숫자, [위치지정])
  
*/

SELECT TRUNC(123.789) FROM DUAL;
SELECT TRUNC(123.789, 1) FROM DUAL; -- 소숫점 첫째짜리 까지
SELECT TRUNC(123.789, -1) FROM DUAL; -- ,,??  질문

SELECT TRUNC(-123.789) FROM DUAL;
SELECT TRUNC(-123.789, -2) FROM DUAL; -- 얘도,,


---------------------------------단일행 함수-------------------------------------
--==============================================================================
--                               날짜 처리 함수
--==============================================================================
/*
    * SUSDATE : 시스템 날짜 및 시간 반환
*/

SELECT sysdate FROM dual;


--------------------------------------------------------------------------------
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수
    
    [표현법]
   MONTHS_BETWEEN(날짜, 날짜)  
*/

SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE "근무일수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) "근무일수"
  FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "근무개월수"
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
FROM EMPLOYEE;

--개월차 이어붙이기
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' "근무개월수"
FROM EMPLOYEE;
--함수를 쓰면?
SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) , '개월차') "근무개월수"
FROM EMPLOYEE;


--------------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE, 숫자) : 특정 날짜에 해당 숫자만큼 개월 수를 더해 반환   
*/

SELECT ADD_MONTHS(sysdate, 1) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사 후 정직원된 날짜(입사후 6개월) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜"
FROM EMPLOYEE;


--------------------------------------------------------------------------------
/*
    * NEXT_DAY(DATE, 요일[문자 | 숫자]) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수    
*/

SELECT sysdate, NEXT_DAY(sysdate, '금요일') FROM DUAL;
SELECT sysdate, NEXT_DAY(sysdate, '금') FROM DUAL;
-- 요일 붙이든 말든 상관 음슴
SELECT sysdate, NEXT_DAY(sysdate, 6) FROM DUAL;
-- 숫자로 금요일 표현해도 상관 x  (6은 금요일)
SELECT sysdate, NEXT_DAY(sysdate, 'FRIDAY') FROM DUAL;
-- 오류 : 현재 언어가 한국이기 때문에 영어로 표현하면 오류가 뜸
-- 그렇다면 어떻게 해야할까!?

-- 언어변경!
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT sysdate, NEXT_DAY(sysdate, 'FRIDAY') FROM DUAL;
----------------------------------------------
SELECT sysdate, NEXT_DAY(sysdate, '금요일') FROM DUAL;
SELECT sysdate, NEXT_DAY(sysdate, '금') FROM DUAL;
----------------------------------------------그럼 한국말이 오류가 뜸

-- 하지만 우리는 한국인이니깐 코뤼아로 다시 바꿔잉
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

--------------------------------------------------------------------------------
/*
    * LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수
*/

SELECT LAST_DAY(sysdate) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사한 날의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;


--------------------------------------------------------------------------------
/*
    * EXTRACT : 특정 날짜로부터 년도 | 월 | 일 값을 추출하여 반환해주는 함수(반환형:NUMBER)
    
    EXTRACT(YEAR FROM DATE) : 년도 추출
    EXTRACT(MONTH FROM DATE) : 월만 추출
    EXTRACT(DAY FROM DATE) : 일만 추출
    
*/

-- 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
EXTRACT(MONTH FROM HIRE_DATE) 입사월,
EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일;

--==============================================================================
--                              형반환 함수
--==============================================================================
/*
    *TO_CHAR : 숫자 또는 날짜 타입의 값을 문자로 변환시켜주는 함수
               반환 결과를 특정 형식에 맞게 출력할 수도 있다.
    
    [표현법]
    To_CHAR( 숫자 | 날짜, [포맷] )
*/

--  숫자 → 문자타입으로 변환
/*
    [포맷]
    * 접두어 : L → LOCAL(설정된 나라)의 화폐단위
    
    -9 : 해당 자리의 숫자를 의미한다.
          - 해당 자리에 값이 없을 경우, 소수점 이상은 공백, 소수점 이하는 0으로 표시
    
    0 : 해당 자리의 숫자를 의미한다.
          - 해당 자리에 값이 없을 경우 0으로 표시하고, 숫자의 길이를 고정적으로 표시할 때 주로 사용한다.
   * FM : 해당 자리에 값이 없을 경우 자리차지를 하지 않음 
*/

SELECT TO_CHAR(1234), 1234 FROM DUAL; -- 문자는 왼쪽정렬, 숫자는 오른쪽 정렬

SELECT TO_CHAR(1234, '999999') FROM DUAL;
SELECT TO_CHAR(1234, '000000') FROM DUAL;
SELECT TO_CHAR(1234, 'L999999') FROM DUAL; -- 오른쪽 정렬

SELECT TO_CHAR(1234, 'L99,999') FROM DUAL; -- 세자리 마다 "," 가 나온다

SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')급여, TO_CHAR(SALARY*12, 'L999,999,999')연봉
FROM employee;

SELECT TO_CHAR(123.456, 'FM99999.999')
FROM DUAL;

SELECT TO_CHAR(123.456, 'FM99999.999'),
       TO_CHAR(123.456, 'FM900000.99'),
       TO_CHAR(0.1000, 'FM9990.999'),
        TO_CHAR(0.1000, 'FM9999.999')
       FROM DUAL;

-- FM빼고
SELECT TO_CHAR(123.456, '99999.999'),
       TO_CHAR(123.456, '900000.99'),
       TO_CHAR(0.1000, '9990.999'),
        TO_CHAR(0.1000, '9999.999')
       FROM DUAL;


----------------------날짜 → 문자타입

--시간 (AM,PM 둘다 상관 없음)
SELECT TO_CHAR(SYSDATE, 'PM') "KOREA",
       TO_CHAR(SYSDATE, 'AM', 'NLS_DATE_LANGUAGE=AMERICAN') "AMERICAN" -- 이렇게 한번에 가능 (밑에처럼 안해도댐)
FROM DUAL;

--미국으로 바꿩
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT TO_CHAR(SYSDATE, 'PM') AMERICAN
FROM DUAL;

--우리나라로 바꿩
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


--12시간 형식, 24시간 형식
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL; -- 12시간 형식
SELECT TO_CHAR(sysdate, 'HH24:MI:SS') from dual; -- 24시간 형식

-- 날짜
SELECT TO_CHAR(sysdate, 'YYYY-MM-DD DAY') from dual;
SELECT TO_CHAR(sysdate, 'Mon, YYYY') from dual;

-- 오류) 한글을 넣으면 안댐!
-- SELECT TO_CHAR(sysdate, 'YYYY년 MM월 DD일 DAY') from dual;
SELECT TO_CHAR(sysdate, 'YYYY"년" MM"월" DD"일" DAY') from dual;
SELECT TO_CHAR(sysdate, 'DL') from dual;
-- 간단하게 DL쓰면댐!

SELECT TO_CHAR(sysdate, 'YY-MM-DD DAY') from dual;

-- 입사일을 ????년 ?월 ?일 ?요일로 출력하세요
SELECT TO_CHAR(HIRE_DATE, 'DL') 입사일 from employee;

-- 년도
/*
    YY : 무조건 '20'이 앞에 붙는다
    RR : 50년을 기준으로 작으면 '20'을 크면 '19'
*/
SELECT TO_CHAR(SYSDATE, 'YYYY'),
          TO_CHAR(SYSDATE, 'YY'),
          TO_CHAR(SYSDATE, 'RRRR'),
          TO_CHAR(SYSDATE, 'RR')
FROM DUAL;


------------월

SELECT TO_CHAR(sysdate, 'MM'),
       TO_CHAR(sysdate, 'MON'),
       TO_CHAR(sysdate, 'MONTH'),
       TO_CHAR(sysdate, 'RM') -- RM은 로마기호로 표현해줌
       FROM dual;
       
------------일

SELECT TO_CHAR(sysdate, 'DDD'), -- 년 기준 며칠째
       TO_CHAR(sysdate, 'DD'), -- 월 기준 며칠째
       TO_CHAR(sysdate, 'D') -- 주 기준(일요일) 며칠째
       FROM dual;

------------요일
SELECT TO_CHAR(sysdate, 'DAY'), 
       TO_CHAR(sysdate, 'DY')
       FROM dual;
       
--------------------------------------------------------------------------------
/*
    TO_DATE : 숫자나 문자를 날짜 타입으로 변환
    TO_DATE(숫자) 날짜, [포맷])
*/

SELECT TO_DATE(20240613) FROM DUAL;
SELECT TO_DATE(240613) FROM DUAL;

SELECT TO_DATE(010610) FROM DUAL; --숫자로 앞이 0일 때 오류
SELECT TO_DATE('010610') FROM DUAL;

SELECT TO_CHAR(TO_DATE('070407 020814','YYMMDD HHMISS'), 'YY-MM-DD HH:MI:SS') FROM DUAL;
-- SELECT TO_CHAR('070407 020814','YYMMDD HHMISS') FROM DUAL;

 
-- SELECT TO_DATE('041030 143000', 'YYMMDD HHMISS') FROM DUAL -- 오류 : 오전 오후로 14시는 없음
SELECT TO_DATE('041030 103000', 'YYMMDD HHMISS') FROM DUAL; -- 위에 오류를 고치는 방법

-- 환경설정 바꾸고 도구 > 환결성정 > 데이터베이스 > NLS > 날짜 포맷을 RRRR/MM/DD 로 변경
SELECT TO_DATE('981213', 'RRMMDD') FROM DUAL; --RR : 50미만 일 대는 현재 세기, 50 이상이면 이전 세기 반영
SELECT TO_DATE('021213', 'RRMMDD') FROM DUAL;

SELECT TO_DATE('981213', 'YYMMDD') FROM DUAL; --YY : 무조건 현재세기로 반영
SELECT TO_DATE('021213', 'YYMMDD') FROM DUAL;



--------------------------------------------------------------------------------
/*
    TO_NUMBER : 문자를 숫자타입으로 변환
    
    [표현법]
    TO_NUMBER(문자,[포맷])
*/

SELECT TO_NUMBER('0123837310') FROM DUAL;
-- 앞에 숫자 0 이있으면 반환 X
SELECT '1000' + '500' FROM DUAL;
--오류 : SELECT '1000' + '5,000' FROM DUAL;
-- ',' 숫자에 컴마가 들어가면 안댄다!
-- 밑에껀 가능
SELECT TO_NUMBER('1,000,000','9,999,999') + TO_NUMBER('50,000','99,999') FROM DUAL;


--==============================================================================
--                             NULL 처리 함수
--==============================================================================
/*
    * NVL(컬럼, 해당컬럼이 NULL일 경우 반환할 값)
*/

SELECT EMP_NAME, NVL(BONUS,0)
FROM employee;

-- 전 사원의 사원명, 연봉(보너스포함)

SELECT EMP_NAME, (SALARY + SALARY*(BONUS))*12 "연봉(보너스포함)"
FROM employee;
SELECT EMP_NAME, (SALARY*(1+BONUS))*12 "연봉(보너스포함)"
FROM employee;
-- 두개 다 같은 말

SELECT EMP_NAME, (SALARY + SALARY*NVL(BONUS,0))*12 "연봉(보너스포함)"
FROM employee;
SELECT EMP_NAME, (SALARY*(1+NVL(BONUS,0)))*12 "연봉(보너스포함)"
FROM employee;
SELECT EMP_NAME, (SALARY*NVL(1+BONUS,1))*12 "연봉(보너스포함)"
FROM employee;
-- 세개 다 같은 말

-- 전 사원의 사원명, 부서코드(부서가 없으면 '부서없음') 나오게 조회

SELECT EMP_NAME, NVL(DEPT_CODE,'부서없음') 부서코드
FROM employee;

--------------------------------------------------------------------------------
/*
    * NVL2(컬럼, 반환 값1, 반환 값2)
    - 반환 값1 : 컬럼에 값이 존재할 때 반환되는 값
    - 반환 값2 : 컬럼에 값이 NULL일 때 반환되는 값
*/

-- EMPLOYEE에서 사원명, 급여, 보너스, 성과급(보너스를 받는사람은 50%, 보너스를 못받는 사람은 10%)
SELECT EMP_NAME, SALARY, BONUS, SALARY*NVL2(BONUS, 0.5, 0.1) 성과급
FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 부서(부서에 속해있으면 '부서있음', 부서에 속해있지 않으면 '부서없음')
SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * NULLIF(비교대상1, 비교대상2)
    - 두 개의 값이 일치하면 NULL 반환
    - 두 개의 값이 일치하지 않으면 비교대상1 값을 반환
*/

SELECT NULLIF('1234', '1234') FROM DUAL;
SELECT NULLIF('1234', '5678') FROM DUAL;


--==============================================================================
--                           선택함수
--==============================================================================
/*
    * DECODE(비교하고자하는 대상 (컬럼 | 산술연산 | 함수식), 비교값1, 결과값1, 비교값2, 결과값2, .... )
    
    SWITCH(비교대상){
    CASE 비교값1 : 결과값1
    CASE 비교값2 : 결과값2
    ....
    DEFAULT : 
    } 
    랑 똑같은겨 ~
*/

-- EMPLOYEE에서 사번, 사원명, 주민번호, 성별(남,여) 조회

SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여','3','남','4','여') 성별
FROM employee;


-- EMPLOYEE에서 사원명, 급여, 직급코드, 인상된 급여( 급여 조회시 각 직급별로 인상하여 조회 )
-- J7인 사원은 급여를 10%인상 (SALARY*1.1)
-- 왜 1.1 인가 ? -> 월급*1 + 월급*0.1 을 줄여서 월급(1+0.1) 댄겨
    -- J6인 사원은 급여를 15%인상 (SALARY*1.15)
        -- J5인 사원은 급여를 20%인상 (SALARY*1.2)
            -- 그 외 인 사원은 급여를 5%인상 (SALARY*1.05)

SELECT EMP_ID, SALARY, JOB_CODE, DECODE(JOB_CODE, 'J7', SALARY*1.1, 'J6', SALARY*1.15, 'J5', SALARY*1.2, SALARY*1.05) "인상된 월급"
FROM employee;


--------------------------------------------------------------------------------
/*
    *CASE WHEN THEN
     END
    
    [표현법]
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값 N
    END
    
    -- 
    IF(조건식1) 결과값1
    ELSE IF(조건식2) 결과값2
    ....
    ELSE 결과값N
    과 똑같은거!
*/

-- EMPLOYEE에서 사원명, 급여, 급수(급여가 5백만원 이상이면 '고급' 그렇지 않으면 350만원 이상 '중급' 나머지는 '초급')

SELECT EMP_NAME, SALARY,
       CASE when SALARY >= 5000000 then '고급'
            when SALARY >= 3500000 then '중급'
       ELSE '초급'
       END AS 급수
FROM employee;


--==============================================================================
--                           그룹함수
--==============================================================================
/*
    * SUM(컬럼) : 컬럼들의 값의 합계
*/

-- 전 사원의 총 급여의 합 조회
SELECT SUM(SALARY) FROM employee;

-- 남자 사원의 총 급여의 합
SELECT SUM(SALARY)
FROM employee
--WHERE DECODE(SUBSTR(EMP_NO,8,1),'1','남','3','남') = '남'; 내가 혼자해봐떠
WHERE SUBSTR(EMP_NO,8,1) IN('1', '3');

--부서 코드가 D5인 사원들의 연봉의 합
SELECT SUM(SALARY*12)
FROM employee
WHERE DEPT_CODE IN ('D5');

--부서 코드가 D5인 사원들의 연봉(보너스 포함)의 합 단, NULL 값 안나오게 조회
SELECT SUM((SALARY + SALARY*NVL(BONUS,0))*12) "D5인 사원들의 연봉의 합"
FROM employee
WHERE DEPT_CODE = 'D5';

--------------------------------------------------------------------------------
/*
    AVG(컬럼) : 해당 컬럼들의 평균
*/

SELECT AVG(SALARY)
FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY),-1)
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
   * MIN / MAX : 컬럼 값중에서 가장 큰 값, 가장 작은 값
    
    [표현법]
    MIN(컬럼)
    MAX(컬럼)
*/

SELECT MIN(SALARY), MIN(EMP_NAME), MIN(HIRE_DATE)
FROM employee;

SELECT MAX(SALARY), MAX(EMP_NAME), MAX(HIRE_DATE)
FROM employee;


--------------------------------------------------------------------------------
/*
   * COUNT : 행의 갯수
    
    [표현법]
    COUNT( * | 컬럼 | DISTINCT 컬럼 ) 
    - COUNT(*) : 조회된 결과의 모든 행의 갯수
    - COUNT(컬럼) : 제시한 컬럼에서 NULL값을 제외한 행의 갯수
    - COUNT(DISTINCT 컬럼) : 해당 컬럼 값에서 중복값을 제외한 후 행의 갯수
*/

--전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

--여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN('2','4');

--보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

--부서 배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

--현재 사원들이 총 몇 개의 부서에 분포되어있는지 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

------------------------------------------   종합문제
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME, EMP_NO,
--SUBSTR(EMP_NO,1,2)
TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'),'RRRR') 생년,
SUBSTR(EMP_NO,3,2) 생월,
SUBSTR(EMP_NO,5,2) 생일
FROM EMPLOYEE;

-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME, EMP_NO, RPAD(SUBSTR(EMP_NO, 1, 7), 14, '*') "뒤에 번호 *표시"
FROM EMPLOYEE;

-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME, FLOOR(ABS(HIRE_DATE-SYSDATE)) 근무일수1, FLOOR(SYSDATE-HIRE_DATE) 근무일수2
FROM EMPLOYEE;

-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = '1';

-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT EMP_NAME, CEIL(MONTHS_BETWEEN(sysdate, HIRE_DATE))
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(sysdate, HIRE_DATE)>= 240;

  
-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME, SALARY, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME, DEPT_CODE, TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)), 'YYYY"년" MM"월" DD"일"') 생년월일,
TO_CHAR(sysdate, 'YYYY')-TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)), 'YYYY') || '살' 나이
FROM EMPLOYEE;


-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부
--   , D6면 기획부, D9면 영업부로 처리(EMP_ID, EMP_NAME, DEPT_CODE, 총무부)
--    (단, 부서코드 오름차순으로 정렬)
SELECT EMP_ID, EMP_NAME, DEPT_CODE,
    CASE when DEPT_CODE = 'D5' then '총무부'
         when DEPT_CODE = 'D6' then '기획부'
         ELSE '총무부'
         END AS 부서코드
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY DEPT_CODE ;


-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_ID, EMP_NAME, EMP_NO,
SUBSTR(EMP_NO,1,6) "주민번호 앞자리",
SUBSTR(EMP_NO,8,7) "주민번호 뒷자리",
TO_NUMBER(SUBSTR(EMP_NO,1,6)) + TO_NUMBER(SUBSTR(EMP_NO,8,7)) "주민번호앞 + 주민번호뒤"
FROM EMPLOYEE
WHERE EMP_ID = '201';


-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((SALARY + SALARY*NVL(BONUS,0))*12) "D5인 사원들의 연봉의 합"
FROM employee
WHERE DEPT_CODE = 'D5';


-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      전체 직원 수, 2001년, 2002년, 2003년, 2004

-- 전체 입사년도만 조회
SELECT EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

--2001년, 2002년, 2003년, 2004년 조회
SELECT HIRE_DATE DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2001', 1, 0) "2001년"
FROM EMPLOYEE;

--2001년, 2002년, 2003년, 2004년 개수
SELECT COUNT(*) 전체직원수,
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2001', 1)) "2001년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2002', 1)) "2002년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2003', 1)) "2003년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), '2004', 1)) "2004년"
FROM EMPLOYEE;







