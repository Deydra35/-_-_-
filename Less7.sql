-- 1.��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.

select distinct name 
from users join orders on users.id = orders.user_id; 

-- 2.�������� ������ ������� products � �������� catalogs, ������� ������������� ������.

select products.name, catalogs.name as catalog_name
from products join catalogs on products.catalog_id = catalogs.id; 

-- 3.(�� �������) ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name). ���� from, to � label �������� ���������� �������� �������, ���� name � �������. �������� ������ ������ flights � �������� ���������� �������.

select cities_from.id, `from`, `to`
from 
(select cities.name as `from`, flights.id as id
from cities join flights on cities.label = flights.`from`) as cities_from 
join 
(select cities.name as `to`, flights.id as id
from cities join flights on cities.label = flights.`to`) as cities_to
on cities_from.id = cities_to.id
order by cities_from.id