-- 1. ����� � ������� users ���� created_at � updated_at ��������� ��������������. 
-- ��������� �� �������� ����� � ��������.

UPDATE shop.users 
SET created_at = NOW(),
    updated_at = NOW();
   
-- 2. ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� 
-- VARCHAR � � ��� ������ ����� ���������� �������� � ������� "20.10.2017 8:10". 
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

CREATE TABLE users_new (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);   

INSERT INTO users_new  
  SELECT NULL, name, birthday_at, STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i'), STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i') 
  FROM users;
 
DROP TABLE users;
   
ALTER TABLE users_new RENAME users;

-- 3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, 
-- ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. ���������� ������������� ������ ����� 
-- �������, ����� ��� ���������� � ������� ���������� �������� value. ������, ������� ������ ������ ���������� 
-- � �����, ����� ���� �������.

SELECT value
FROM shop.storehouses_products 
ORDER BY IF( value = 0, 1, 0 ) , value;

-- 4. (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� ('may', 'august')

SELECT name, birthday_at
FROM shop.users 
WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

-- 5. (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.

SELECT * 
FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

-- 1. ����������� ������� ������� ������������� � ������� users
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as medium
FROM shop.users 

-- 2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������. 
-- ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.

SELECT 
	( CASE 
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 0 then 'Monday'
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 1 then 'Tuesday'
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 2 then 'Wednesday'
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 3 then 'Thursday'
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 4 then 'Friday'
   WHEN WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y')) = 5 then 'Saturday'
   ELSE 'Sunday'
   END) AS day_week,
   COUNT(WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y'))) AS count_birthday
FROM shop.users 
GROUP BY WEEKDAY(STR_TO_DATE(CONCAT(DATE_FORMAT(birthday_at, '%d %m'), ' ', DATE_FORMAT(NOW(), '%Y')), '%d %m %Y'));

-- 3. (�� �������) ����������� ������������ ����� � ������� �������

SELECT ROUND(EXP(SUM(LN(value))))
FROM shop.storehouses_products;
-- ������ ��� �� ����������� ����((

