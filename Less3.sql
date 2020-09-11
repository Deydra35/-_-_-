USE vk;

-- создадим таблицу среднее образование, для этого нужна таблица школ, 
-- которая привязана к городам, которая привязана к странам

DROP TABLE IF EXISTS countres;
CREATE TABLE countres (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, -- стран вроде 251, TINYINT NOT NULL вроде 255
    country VARCHAR(60) -- вроде самое длинное "Соединенное Королевство Великобритании и Северной Ирландии"       
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, -- городов вроде 2 667 417
    city VARCHAR(60), -- вроде самое длинное "Лланвайрпуллгуингиллгогерихуирндробуллллантисилиогогого́х"  
    country_id TINYINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (country_id) REFERENCES countres(id) ON UPDATE CASCADE ON DELETE restrict   
);

DROP TABLE IF EXISTS schools;
CREATE TABLE schools (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE, 
    school VARCHAR(100),  
    city_id MEDIUMINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (city_id) REFERENCES cities(id) ON UPDATE CASCADE ON DELETE restrict   
);

DROP TABLE IF EXISTS secondary_educations;
CREATE TABLE secondary_educations (
	id SERIAL, 
    country_id TINYINT UNSIGNED NOT NULL,  
    city_id MEDIUMINT UNSIGNED NOT NULL,
    school_id INT UNSIGNED NOT NULL,  
    start_year YEAR,
    end_year YEAR,
    
    FOREIGN KEY (country_id) REFERENCES countres(id) ON UPDATE CASCADE ON DELETE restrict,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON UPDATE CASCADE ON DELETE restrict, 
    FOREIGN KEY (school_id) REFERENCES schools(id) ON UPDATE CASCADE ON DELETE restrict
);

-- теоретически один человек мог учится в нескольких школах, и в каждой школе в одно
-- и то же время учатся разные люди

DROP TABLE IF EXISTS users_secondary_educations;
CREATE TABLE users_secondary_educations(
	user_id BIGINT UNSIGNED NOT NULL,
	secondary_education_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, secondary_education_id), 
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE restrict,
    FOREIGN KEY (secondary_education_id) REFERENCES secondary_educations(id) ON UPDATE CASCADE ON DELETE restrict
);