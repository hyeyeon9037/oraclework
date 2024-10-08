create table boardtest(
    boardno number primary key,
      title VARCHAR2(50),
    writer varchar2(20),
    content varchar2(500)
);

create sequence seq_boardtest;

insert into boardtest values(seq_boardtest.nextval, '제목1', '나빛나', '나빛나가 쓴 글');
insert into boardtest values(seq_boardtest.nextval, '제목2', '너핑클', '너핑클이 쓴 글');

commit;

----------------------------------------------------------------------------------

insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '김치찌개', 8000, '찌개백반', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '된장찌개', 8000, '찌개백반', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '짜장면', 7000, '이향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '무스비', 12000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '스시', 15000, '스시비쇼쿠', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '짬뽕', 10000, '이향', 'HOT', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '물냉면', 8000, '김밥천국', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '삼선간짜장', 9000, '피챠이', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '기스면', 7000, '만리향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '비빔냉면', 8000, '김밥천국', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '오차즈케', 10000, '스시비쇼쿠', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '팔보채', 30000, '피챠이', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '치라시즈시', 12000, '미소푸', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '제육덮밥', 9000, '국밥', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '깐쇼새우', 30000, '만리향', 'HOT', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '갈비탕', 16000, '국밥', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '하이라이스', 8000, '미소푸', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '비빔밥', 8000, '찌개백반', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '탕수육', 25000, '이향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '규동', 9000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '유산슬', 30000, '피챠이', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '텐동', 10000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '야끼소바', 8000, '스시비쇼쿠', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '불고기', 10000, '김밥천국', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '카마메시', 12000, '미소푸', 'MILD', 'JP');
commit;