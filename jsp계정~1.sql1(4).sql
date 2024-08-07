CREATE TABLE REPLY (
    NO NUMBER PRIMARY KEY,
    CONTENT VARCHAR2(400),
    REF NUMBER,
    NAME VARCHAR2(20),
    REDATE DATE
);

CREATE SEQUENCE SEQ_REPLY NOCACHE;

INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '와우!! 첫 댓글', 1, '김처음', '2024/07/01');
INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '굉장하군요', 1, '박굉장', '2024/07/20');
INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '멋져요', 1, '이멋짐', '2024/07/26');

commit;
