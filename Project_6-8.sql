-- при заполнении таблицы cheques_products нельзя добавить один и тот же номер заказа с другим покупателем

DROP TRIGGER IF EXISTS check_order_user;
DELIMITER $$
$$
create trigger check_order_user before insert on cheques_products
for each row 
begin 	
	set @user_exist := (select count(user_id) from cheques_products where order_number = new.order_number);
	set @user_id := (select user_id from cheques_products where order_number = new.order_number limit 1);
	
	if @user_exist > 0 and new.user_id != @user_id then 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Данный заказ закреплен за другим покупателем!!';
	end if;
END$$
DELIMITER ;

-- По смыслу, в чеке указывается сумма по всем позициям заказа, т.е. таблица должна заполняться по данным 
-- таблицы cheques_products

DROP TRIGGER IF EXISTS insert_cheques;
delimiter //
CREATE TRIGGER insert_cheques AFTER INSERT ON cheques_products
FOR EACH ROW
BEGIN
	set @sum_cheq := (select sum(cp.count_product*p2.price) as sum_cheq  
		from cheques_products cp join products p on cp.product_id = p.product_id 
		join prices p2 on p.product_id = p2.product_id 
		where cp.order_number = new.order_number and NOW() between p2.start_date and p2.finish_date ); 


	INSERT INTO cheques (order_number, purchase_amount)
	VALUES (new.order_number, @sum_cheq) 
	ON DUPLICATE KEY UPDATE order_number = new.order_number,
		purchase_amount = @sum_cheq;
END //
delimiter ;

/* Процедура, которая будет подбирать рекомендованные товары к покупке исходя из возраста детей и популярности 
 * товара, если у покупателя указаны дети, иначе рекомендовать популярные настолки
 * 
 */
DROP PROCEDURE IF EXISTS sp_recommendation_product;

delimiter //

CREATE PROCEDURE sp_recommendation_product(for_user_id INT) 
BEGIN
	DECLARE count_children TINYINT;
	DECLARE child_id_sp INT UNSIGNED;
	DECLARE child_age TINYINT;
	DECLARE child_gender CHAR(1);
	
	set count_children = (select count(child_id) from children where user_id = for_user_id);

	if count_children = 0 then
		select p2.product_name , p3.price 
		from cheques_products cp join products p2 on cp.product_id = p2.product_id 
			join category_products cp2 on p2.category_id = cp2.id 
			join prices p3 on p3.product_id = p2.product_id 
		where NOW() between p3.start_date and p3.finish_date and cp2.product_tipe = 'игры'
		group by cp.product_id 
		order by sum(cp.count_product) desc limit 5;
	else
		-- поскольку детей может быть несколько, рекомендации подбираем для случайного 
	
		set child_id_sp = (select child_id from children where user_id = for_user_id order by rand() limit 1);
		set child_age = (select TIMESTAMPDIFF(YEAR, c.birthday , NOW()) from children c where c.child_id = child_id_sp);
		set child_gender = (select gender from children where child_id = child_id_sp);
	
		select p.product_name, p2.price
		from cheques_products cp join products p on cp.product_id = p.product_id 
			left join prices p2 on p2.product_id = p.product_id 
				join category_products cp2 on cp2.id = p.category_id 
		where (NOW() between p2.start_date and p2.finish_date) and cp2.min_age <= child_age and cp2.max_age >= child_age 
			and (cp2.gender = child_gender or cp2.gender = 'u')
		group by p.product_id 
		order by sum(cp.count_product) desc limit 5;
	end if;


END//

delimiter ;

-- call sp_recommendation_product(2);
-- call sp_recommendation_product(4);


-- функция возвращает имя и фамилию человека, который сделал больше всего покупок в заданном месяце года

DROP FUNCTION IF EXISTS my_shop.func_best_user_month;

DELIMITER $$
$$
CREATE FUNCTION my_shop.func_best_user_month(check_data char(7))
RETURNS Char(101) READS SQL DATA
BEGIN
	DECLARE best_user_id INT;
	DECLARE resalt CHAR(101);
	
	set best_user_id = (select cp.user_id 
							from cheques c join 
								(select distinct order_number, user_id from cheques_products) cp on c.order_number = cp.order_number
							where c.purchase_date like CONCAT(check_data, '%')
							group by cp.user_id 
							order by sum(c.purchase_amount) desc limit 1);
						
	set resalt = (select CONCAT(firstname, ' ', lastname) from users where id = best_user_id);

	if resalt IS NULL then
		set resalt = 'В данном месяце покупок не было';
	end if;
						
	return resalt;	
END$$
DELIMITER ;

-- select my_shop.func_best_user_month('2020-10');
-- select my_shop.func_best_user_month('2020-09');

-- собственно хорошо бы понимать конверсию по рассылкам

CREATE or replace view mailing_conversion
AS
select m.mailing_type_id as `id рассылки`, count(m.user_id) as `отправлено`, m1.`доставлено`, 
	m1.`доставлено`/count(m.user_id)*100 as `конверсия отправлено/доставлено`, m2.`прочитано`,
	m2.`прочитано`/m1.`доставлено`*100 as `конверсия доставлено/прочитано`, m3.`переход`, 
	m3.`переход`/m2.`прочитано`*100 as `конверсия прочитано/переход` ,m4.`покупка`,
	m4.`покупка`/m3.`переход`*100 as `конверсия переход/покупка`,
	m4.`покупка`/count(m.user_id)*100 as `общая конверсия`
from mailings m join
 (select mailing_type_id, count(user_id) as `доставлено` from mailings 
 	where mailing_status = 'доставлено' or mailing_status = 'прочитано' 
 		or mailing_status = 'переход' or mailing_status = 'покупка'
 	group by mailing_type_id) as m1 on m.mailing_type_id = m1.mailing_type_id
 	join (select mailing_type_id, count(user_id) as `прочитано` from mailings 
 			where mailing_status = 'прочитано' 
 				or mailing_status = 'переход' or mailing_status = 'покупка'
 			group by mailing_type_id) as m2 on m.mailing_type_id = m2.mailing_type_id
 	join (select mailing_type_id, count(user_id) as `переход` from mailings 
 			where mailing_status = 'переход' or mailing_status = 'покупка'
 			group by mailing_type_id) as m3 on m.mailing_type_id = m3.mailing_type_id
 	join (select mailing_type_id, count(user_id) as `покупка` from mailings 
 			where mailing_status = 'покупка'
 			group by mailing_type_id) as m4 on m.mailing_type_id = m4.mailing_type_id
group by `id рассылки`;

-- select * from mailing_conversion; 

-- хорошо бы иметь список родителей с емайлами, до др детей которых осталось меньше двух недель

CREATE or replace view child_birth_for_mailing
AS
select c.child_name, c.birthday, concat(u2.firstname, ' ', u2.lastname) as `ИФ`, u2.email 
from children c join users u2 on c.user_id = u2.id 
where concat(date_format(NOW(),'%Y'), '-', date_format(c.birthday, '%m-%d')) 
between CURDATE() and DATE_ADD(CURDATE(), INTERVAL 14 DAY);

-- select * from child_birth_for_mailing;



