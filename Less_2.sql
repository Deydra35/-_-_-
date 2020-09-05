/* 2. �������� ���� ������ example, ���������� � ��� ������� users, 
 * ��������� �� ���� ��������, ��������� id � ���������� name.
 */

create database if not exists example;
show databases;
use example;
show tables;
create table if not exists users(id INT, name TEXT);
show tables;
DESCRIBE users;

/* 3. �������� ���� ���� ������ example �� ����������� �������, 
 * ���������� ���������� ����� � ����� ���� ������ sample.
 */

--� ��������� ������: mysqldump -u root -p example > sample.sql

/* ������������-������ �������� ��������� .my.cnf ��������� ������ �� �����������
 * ������. �������� ��������� ��������  .my.cnf,  .my.ini, .mylogin.cnf ���������
 *  � ���������� windows, C:\my.cnf, \MySQL.mylogin.cnf, 
 * C:\Program Files\MySQL\MySQL Server 8.0, 
 * C:\Program Files\MySQL\MySQL Server 8.0\bin, �������� ���������� ������������ �
 * ��� � �����-�� ������, ����� �������� ��� ������� � ��������� ������ - 
 * ������ ���� ERROR 1045 (28000): Access denied for user 'ODBC'@'localhost' (using password: NO) 
 * 
 * ������ ����������, �� ����� �������� �� ������..
 */
create database if not exists sample;
use sample;
SOURCE sample.sql;
show tables;
show databases;
