DROP DATABASE IF EXISTS my_shop;
CREATE DATABASE my_shop;
USE my_shop;

DROP TABLE IF EXISTS discount_cards;
CREATE TABLE discount_cards (
	discount_card_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	activation_date DATETIME DEFAULT NOW()    
) COMMENT 'скидочные карты';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    middle_name VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), 
 	discount_card_id INT UNSIGNED NOT NULL,
	phone BIGINT UNSIGNED UNIQUE, 
	
	FOREIGN KEY (discount_card_id) REFERENCES discount_cards(discount_card_id) ON UPDATE CASCADE ON DELETE restrict,	
	
    INDEX users_firstname_lastname_idx(firstname, middle_name, lastname)
) COMMENT 'клиенты';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id INT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
    created_at DATETIME DEFAULT NOW(),
    address VARCHAR(250),
    
    FOREIGN KEY (user_id) REFERENCES users(id)	ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'профиль клиентов';

DROP TABLE IF EXISTS children;
CREATE TABLE children (
	child_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	child_name CHAR(50),
    gender CHAR(1),
    birthday DATE,
    user_id INT UNSIGNED NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id)	ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'дети';

DROP TABLE IF EXISTS category_products;
CREATE TABLE ategory_products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	product_tipe ENUM ('одежда','игры','игрушки','книги','питание','гигиена'),
	min_age TINYINT,
    max_age TINYINT DEFAULT 99  
)COMMENT 'категории товаров';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	product_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	category_id INT UNSIGNED NOT NULL,
	product_name CHAR(50),
        
    FOREIGN KEY (category_id) REFERENCES category_products(id)	ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'товары';

DROP TABLE IF EXISTS prices;
CREATE TABLE prices (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	product_id INT UNSIGNED NOT NULL,
	price INT UNSIGNED NOT NULL,
	start_date DATETIME DEFAULT NOW(),
	finish_date DATETIME,
        
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'цены';

DROP TABLE IF EXISTS cheques;
CREATE TABLE cheques (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	purchase_amount INT UNSIGNED NOT NULL,
	purchase_date DATETIME DEFAULT NOW(),
	        
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'покупки/чеки';

DROP TABLE IF EXISTS cheques_products;
CREATE TABLE cheques_products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	cheque_id INT UNSIGNED NOT NULL,
	product_id INT UNSIGNED NOT NULL,
	        
    FOREIGN KEY (cheque_id) REFERENCES cheques(id) ON UPDATE CASCADE ON DELETE restrict,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'чеки-товары';

DROP TABLE IF EXISTS mailing_types;
CREATE TABLE mailing_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	mailing_tipe ENUM ('информационная','поздравительная','о скидках','рекомендательная'),
	header CHAR(50),
	body TEXT		
)COMMENT 'типы рассылок';

DROP TABLE IF EXISTS mailings;
CREATE TABLE mailings (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL,
	mailing_type_id INT UNSIGNED NOT NULL,
	mailing_date DATETIME DEFAULT NOW(),
	mailing_status ENUM ('доставлено','прочитано','переход','покупка'),
	        
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE restrict,
    FOREIGN KEY (mailing_type_id) REFERENCES mailing_types(id) ON UPDATE CASCADE ON DELETE restrict
)COMMENT 'рассылки';


