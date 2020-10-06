-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

--  меня база sample содержит только поля id и name
insert into sample.users
	select id, name 
	from shop.users 
	where shop.users.id = 1;

delete from shop.users 
where id = 1;

COMMIT;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.

create or replace view view_products_catalogs as
select products.name as product_name, catalogs.name as catalog_name
from products join catalogs on products.catalog_id = catalogs.id;

select * from view_products_catalogs;

-- 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму 
-- пользователю shop — любые операции в пределах базы данных shop.

create user 'shop_read'@'localhost';

create user 'shop'@'localhost';

grant select on shop.* to 'shop_read'@'localhost';

grant all on shop.* to 'shop'@'localhost';


-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего
-- времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция
-- должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS shop.hellow;

DELIMITER $$
$$
CREATE FUNCTION shop.hellow()
RETURNS text DETERMINISTIC
BEGIN 
	case
			when hour(now()) between 6 and 11 then return "Доброе утро";
			when hour(now()) between 12 and 15 then return "Добрый день";
			when hour(now()) between 18 and 24 then return "Добрый вечер";
			when hour(now()) between 0 and 5 then return "Доброй ночи";
		end case;
END$$
DELIMITER ;

select hellow();
	


-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное
-- значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля
-- были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- не работает, не ясно почему, ошибка: SQL Error [1064] [42000]: You have an error in your SQL syntax; 
-- check the manual that corresponds to your MySQL server version for the right syntax to use near 'messege_text = 'Введите имя или описание';
-- end if;
-- END$$' at line 6
DELIMITER $$
$$
create trigger check_not_null_name_description_before_insert before insert on products
for each row 
begin 
	if new.name is null and new.description is null then 
		signal sqlstate '45000' 
			SET MESSEGE_TEXT = 'Введите имя или описание';
	end if;
END$$
DELIMITER ;



