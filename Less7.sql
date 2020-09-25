-- 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

select distinct name 
from users join orders on users.id = orders.user_id; 

-- 2.Выведите список товаров products и разделов catalogs, который соответствует товару.

select products.name, catalogs.name as catalog_name
from products join catalogs on products.catalog_id = catalogs.id; 

-- 3.(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

select cities_from.id, `from`, `to`
from 
(select cities.name as `from`, flights.id as id
from cities join flights on cities.label = flights.`from`) as cities_from 
join 
(select cities.name as `to`, flights.id as id
from cities join flights on cities.label = flights.`to`) as cities_to
on cities_from.id = cities_to.id
order by cities_from.id