-- 조인(JOIN)
--  데이터베이스의 테이블들 간 결합을 의미한다.
--  여러 개의 테이블에 자원들이 흩어져 있는 상태에서 데이터를
--  마치 하나의 테이블에서 보는 것처럼 결과를 내고 싶을 때 
--  JOIN을 사용한다.

-- 예를 들어  원하는 결과가 다음과 같다면
--  사번, 이름, 직종, 입사일, 부서코드, 부서명
--  |------ emp ------||-- dept ---|
-- 이렇게 하나의 테이블에 있는 것 처럼 결과를 얻기 위해
-- 여러 개의 테이블 간 기본키와 외래키의 연결을 이용하여
-- JOIN을 사용할 때 가능하다. 

SELECT e.empno, e.ename, e.job, 
  e.hiredate, d.deptno, d.dname
FROM emp e INNER JOIN dept d
ON e.deptno = d.deptno;

-- 조인의 종류
--   - INNER JOIN: 교집합
SELECT * FROM emp INNER JOIN dept
ON emp.deptno = dept.deptno;

-- 각 부서별 도심명을 출력하자!
--  부서코드, 부서명, 도시코드, 도시명 순으로 출력하자!
SELECT d.deptno, d.dname, d.loc_code, l.city
FROM dept d INNER JOIN locations l
ON d.loc_code = l.loc_code;

-- 위는 조인된 테이블들 끼리 참조되는 동일한 자원들만 보여준다.
-- 그래서 사번이 1000번인 이도라는 사원은 결과로
-- 포함시키지 않는다. 때에따라 이도같은 자원들도
-- 결과로 포함시키고 싶을 때가 있다. 이때 사용하는 것이
-- Outer Join(LEFT/RIGHT)이다.

-- LEFT JOIN
-- 왼쪽 테이블의 자원들을 연결성을 고려하지 않고 
-- 모두 출력하고 
-- 오른쪽의 테이블의 자원들은 연결되어 있는 자원들만 출력된다.
SELECT e.empno, e.ename, e.job,
  e.deptno, d.dname
FROM emp e LEFT OUTER JOIN dept d
ON e.deptno = d.deptno;

-- 현재 사원들과 부서간의 부서는 존재하지만 
-- 구성원이 없는 부서가 무엇인지? 알아내자!
SELECT e.*, d.deptno,d.dname
FROM emp e RIGHT OUTER JOIN dept d
ON e.deptno = d.deptno;

-- 문제) emp테이블에서 직종이 'ANALYST'인 사원들의
--  정보를 사번,이름,직종,급여,부서명,도시코드 순으로 출력하자
SELECT e.empno, e.ename, e.job, e.sal,
	d.dname, d.loc_code
FROM emp e LEFT OUTER JOIN dept d
ON e.deptno = d.deptno
WHERE e.job = 'ANALYST';

-- 또는
SELECT e.empno, e.ename, e.job, e.sal,
	d.dname, d.loc_code
FROM (SELECT * FROM emp 
	WHERE job = 'ANALYST') e 
LEFT OUTER JOIN dept d
ON e.deptno = d.deptno;

-- 위의 내용에서 도서명을 하나 더 추가해서 출력하려 한다.
SELECT e.empno, e.ename, e.job, e.sal,
	d.dname, d.loc_code, l.city
FROM (SELECT * FROM emp 
	WHERE job = 'ANALYST') e 
LEFT OUTER JOIN dept d
ON e.deptno = d.deptno 
LEFT OUTER JOIN locations l 
ON d.loc_code = l.loc_code;

-- 또는
SELECT e.empno, e.ename, e.job, e.sal,
  d.deptno, d.dname, l.city
FROM emp e, dept d, locations l
WHERE e.deptno=d.deptno 
AND d.loc_code=l.loc_code 
AND e.job = 'ANALYST';

-- 예문) 'DALLAS'에서 근무하는 사원들의 정보를
--    사번,이름,직종,입사일,부서코드,도시명 순으로 출력하자

SELECT e.empno,e.ename,e.job,
	e.hiredate,d.deptno,l.city
FROM emp e, dept d,
  (SELECT * FROM locations 
   WHERE city = 'DALLAS') l
WHERE e.deptno=d.deptno 
AND d.loc_code = l.loc_code;

-- 또는
SELECT e.empno,e.ename,e.job,
	e.hiredate,d.deptno,l.city
FROM emp e INNER JOIN dept d 
INNER JOIN 
  (SELECT * FROM locations 
   WHERE city = 'DALLAS') l
ON e.deptno = d.deptno 
AND d.loc_code = l.loc_code;

-- 문제) 각 사원들의 관리자(MGR)가 누구인지를 알아내어
--  사번,이름,관리자사번(MGR),관리자명 순으로 출력하자!
SELECT e.empno,e.ename,e.mgr, e2.ename
FROM emp e INNER JOIN emp e2
ON e.mgr = e2.empno;


-- DDL : CREATE, ALTER, DROP

-- 도서들을 저장하는 테이블 생성
--  도서에 필요한 정보(도서명, 저자, 출판사, 가격, 등록일)
CREATE TABLE book_t(
  b_idx BIGINT AUTO_INCREMENT,
  title VARCHAR(100),
  author VARCHAR(50),
  press VARCHAR(50),
  price DECIMAL(9,1),
  CONSTRAINT book_t_pk PRIMARY KEY(b_idx)
);

-- 테이블 수정(컬럼추가)
--  등록일 컬럼을 press컬럼 뒤에 컬럼을 추가하자!
ALTER TABLE book_t
ADD reg_date DATE NULL AFTER press;

-- 테이블 수정(컬럼의 자료형 변경)
--  제목의 자료형 길이를 200으로 변경하고자 한다.
ALTER TABLE book_t
MODIFY title VARCHAR(200);

-- 테이블 수정(컬럼명 변경)
--  컬럼 title을 subject로 변경하자!
ALTER TABLE book_t
RENAME COLUMN title TO subject;

-- 테이블 수정(컬럼 삭제)
--  출판사(press) 정보는 삭제하자!
ALTER TABLE book_t
DROP COLUMN press;


-- 회원정보(member_t)를 저장하는 테이블이 필요한 상황이다.
--  회원(회원명, 이메일, 전화번호)가 필요함!
CREATE TABLE member_t(
  m_idx BIGINT AUTO_INCREMENT,
  m_name VARCHAR(50),
  m_email VARCHAR(100),
  m_phone VARCHAR(20),
  CONSTRAINT member_t_pk PRIMARY KEY(m_idx)
);

-- 데이터 추가(INSERT)
INSERT INTO member_t(m_name,m_email,m_phone)
VALUES('일지매','il111@korea.com','010');

-- 데이터 확인
SELECT * FROM member_t;

INSERT INTO member_t(m_name)
VALUES('마루치');

-- 회원이 등록되는 날짜정보를 추가하지 못한 상황이다.
--  회원 등록일(reg_date)를 추가하자!
ALTER TABLE member_t
ADD reg_date DATE NULL;

-- reg_date라는 컬럼의 이름을 write_date로
-- 변경하자!
ALTER TABLE member_t
RENAME COLUMN reg_date TO write_date;

-- 데이터 수정(UPDATE)
-- 일지매라는 이름을 이지매로 수정하자!
-- 일지매의 기본키로 조건을 부여하고 수정한다.
UPDATE member_t
SET m_name = '김아무개'
WHERE m_idx = 1;

-- 회원번호가 2번인 회원의 이름을 '이도'로 그리고
-- 이메일은 'lee@korea.com'으로 변경하자!
UPDATE member_t
SET m_name = '이도',
	m_email = 'lee@korea.com'
WHERE m_idx = 2;

SELECT * FROM member_t;

-- 자원삭제(DELETE)
--  m_idx가 2번인 자원을 삭제하자!
DELETE FROM member_t
WHERE m_idx = 2; 





