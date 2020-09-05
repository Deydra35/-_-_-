/* 2. Создайте базу данных example, разместите в ней таблицу users, 
 * состоящую из двух столбцов, числового id и строкового name.
 */

create database if not exists example;
show databases;
use example;
show tables;
create table if not exists users(id INT, name TEXT);
show tables;
DESCRIBE users;

/* 3. Создайте дамп базы данных example из предыдущего задания, 
 * разверните содержимое дампа в новую базу данных sample.
 */

--В командной строке: mysqldump -u root -p example > sample.sql

/* пользователь-пароль указываю поскольку .my.cnf заработал только на виртуальной
 * машине. Локально пробовала варианты  .my.cnf,  .my.ini, .mylogin.cnf размещать
 *  в директории windows, C:\my.cnf, \MySQL.mylogin.cnf, 
 * C:\Program Files\MySQL\MySQL Server 8.0, 
 * C:\Program Files\MySQL\MySQL Server 8.0\bin, домашней директории пользователя и
 * еще в каких-то местах, также заходила под админом в командную строку - 
 * ошибка одна ERROR 1045 (28000): Access denied for user 'ODBC'@'localhost' (using password: NO) 
 * 
 * Писала наставнику, но ответ получить не успела..
 */
create database if not exists sample;
use sample;
SOURCE sample.sql;
show tables;
show databases;
