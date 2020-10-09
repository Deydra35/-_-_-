-- —оздайте таблицу logs типа Archive. ѕусть при каждом создании записи в таблицах users, catalogs и products
-- в таблицу logs помещаетс€ врем€ и дата создани€ записи, название таблицы, идентификатор первичного ключа и
-- содержимое пол€ name.

DROP TABLE IF EXISTS logs;
CREATE TABLE IF NOT EXISTS logs (
   date_time DATETIME DEFAULT NOW(),
   name_table CHAR(20),
   id INT UNSIGNED NOT NULL,
   name_from_table VARCHAR(255)
 ) ENGINE=ARCHIVE;

SELECT
  ENGINE
FROM
  information_schema.TABLES
WHERE
  TABLE_SCHEMA = 'shop' AND TABLE_NAME = 'logs';
 
 
DROP TRIGGER IF EXISTS log_users;
delimiter //
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, id, name_from_table)
	VALUES ('users', NEW.id, NEW.name);
END //
delimiter ;


DROP TRIGGER IF EXISTS log_catalogs;
delimiter //
CREATE TRIGGER log_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, id, name_from_table)
	VALUES ('catalogs', NEW.id, NEW.name);
END //
delimiter ;


DROP TRIGGER IF EXISTS log_products;
delimiter //
CREATE TRIGGER log_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (name_table, id, name_from_table)
	VALUES ('products', NEW.id, NEW.name);
END //
delimiter ;
