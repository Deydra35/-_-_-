-- 1. � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������. 
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.

START TRANSACTION;

--  ���� ���� sample �������� ������ ���� id � name
insert into sample.users
	select id, name 
	from shop.users 
	where shop.users.id = 1;

delete from shop.users 
where id = 1;

COMMIT;

-- 2. �������� �������������, ������� ������� �������� name �������� ������� �� ������� products � 
-- ��������������� �������� �������� name �� ������� catalogs.

create or replace view view_products_catalogs as
select products.name as product_name, catalogs.name as catalog_name
from products join catalogs on products.catalog_id = catalogs.id;

select * from view_products_catalogs;

-- 1. �������� ���� ������������� ������� ����� ������ � ���� ������ shop. 
-- ������� ������������ shop_read ������ ���� �������� ������ ������� �� ������ ������, ������� 
-- ������������ shop � ����� �������� � �������� ���� ������ shop.

create user 'shop_read'@'localhost';

create user 'shop'@'localhost';

grant select on shop.* to 'shop_read'@'localhost';

grant all on shop.* to 'shop'@'localhost';


-- 1. �������� �������� ������� hello(), ������� ����� ���������� �����������, � ����������� �� ��������
-- ������� �����. � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����", � 12:00 �� 18:00 �������
-- ������ ���������� ����� "������ ����", � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".
DROP FUNCTION IF EXISTS shop.hellow;

DELIMITER $$
$$
CREATE FUNCTION shop.hellow()
RETURNS text DETERMINISTIC
BEGIN 
	case
			when hour(now()) between 6 and 11 then return "������ ����";
			when hour(now()) between 12 and 15 then return "������ ����";
			when hour(now()) between 18 and 24 then return "������ �����";
			when hour(now()) between 0 and 5 then return "������ ����";
		end case;
END$$
DELIMITER ;

select hellow();
	


-- 2. � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������. 
-- ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� ��������������
-- �������� NULL �����������. ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ����
-- ���� ���������. ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

-- �� ��������, �� ���� ������, ������: SQL Error [1064] [42000]: You have an error in your SQL syntax; 
-- check the manual that corresponds to your MySQL server version for the right syntax to use near 'messege_text = '������� ��� ��� ��������';
-- end if;
-- END$$' at line 6
DELIMITER $$
$$
create trigger check_not_null_name_description_before_insert before insert on products
for each row 
begin 
	if new.name is null and new.description is null then 
		signal sqlstate '45000' 
			SET MESSEGE_TEXT = '������� ��� ��� ��������';
	end if;
END$$
DELIMITER ;



