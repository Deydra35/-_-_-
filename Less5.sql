-- 1. ѕусть в таблице users пол€ created_at и updated_at оказались незаполненными. 
-- «аполните их текущими датой и временем.

UPDATE shop.users 
SET created_at = NOW(),
    updated_at = NOW();
   
-- 2. “аблица users была неудачно спроектирована. «аписи created_at и updated_at были заданы типом 
-- VARCHAR и в них долгое врем€ помещались значени€ в формате "20.10.2017 8:10". 
-- Ќеобходимо преобразовать пол€ к типу DATETIME, сохранив введеные ранее значени€.

CREATE TABLE users_new (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '»м€ покупател€',
  birthday_at DATE COMMENT 'ƒата рождени€',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);   

INSERT INTO users_new  
  SELECT NULL, name, birthday_at, STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i'), STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i') 
  FROM users;
 
DROP TABLE users;
   
ALTER TABLE users_new RENAME users;

-- 3. ¬ таблице складских запасов storehouses_products в поле value могут встречатьс€ самые разные цифры: 0, 
-- если товар закончилс€ и выше нул€, если на складе имеютс€ запасы. Ќеобходимо отсортировать записи таким 
-- образом, чтобы они выводились в пор€дке увеличени€ значени€ value. ќднако, нулевые запасы должны выводитьс€ 
-- в конце, после всех записей.

SELECT value
FROM shop.storehouses_products 
ORDER BY IF( value = 0, 1, 0 ) , value;

-- 4. (по желанию) »з таблицы users необходимо извлечь пользователей, родившихс€ в августе и мае. 
-- ћес€цы заданы в виде списка английских названий ('may', 'august')

SELECT name, birthday_at
FROM shop.users 
WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

-- 5. (по желанию) »з таблицы catalogs извлекаютс€ записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); ќтсортируйте записи в пор€дке, заданном в списке IN.

SELECT * 
FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);

-- 1. ѕодсчитайте средний возраст пользователей в таблице users
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) as medium
FROM shop.users 

-- 2. ѕодсчитайте количество дней рождени€, которые приход€тс€ на каждый из дней недели. 
-- —ледует учесть, что необходимы дни недели текущего года, а не года рождени€.

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

-- 3. (по желанию) ѕодсчитайте произведение чисел в столбце таблицы

SELECT ROUND(EXP(SUM(LN(value))))
FROM shop.storehouses_products;
-- только тут не учитываютс€ нули((

