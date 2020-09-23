-- 1. ����� ����� ��������� ������������. �� ���� ������������� ���. ���� ������� ��������, 
-- ������� ������ ���� ������� � ��������� ������������� (������� ��� ���������).

set @user_id = 1;

select firstname, lastname, count(from_user_id) as count_mess
from users join messages on users.id = messages.from_user_id
where @user_id = to_user_id
group by from_user_id
order by count_mess desc limit 1

-- 2. ���������� ����� ���������� ������, ������� �������� ������������ ������ 10 ���..

select count(id)
from likes JOIN profiles ON likes.user_id = profiles.user_id 
where TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) <10;

-- 3. ���������� ��� ������ �������� ������ (�����): ������� ��� �������.

select  CASE (gender)
         WHEN 'm' THEN '�������'
         WHEN 'f' THEN '�������'
         ELSE '�� ������'
    END AS gender, 	
count(likes.id) as count_gender
from profiles join likes on likes.user_id = profiles.user_id 
group by gender 
order by count_gender desc 
