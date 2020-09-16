-- ii. �������� ������, ������������ ������ ���� (������ firstname) ������������� ��� ���������� � ���������� �������

SELECT DISTINCT firstname 
FROM vk.users 
ORDER BY firstname; 

-- �������� ������, ���������� ������������������ ������������� ��� ���������� (���� is_active = false). �������������� �������� ����� ���� � ������� profiles �� ��������� �� ��������� = true (��� 1)

ALTER TABLE vk.profiles ADD COLUMN is_active tinyint(1) NOT NULL DEFAULT '1';

UPDATE vk.profiles 
SET is_active = 0
WHERE (
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) 
  ) < 18;
 
 -- �������� ������, ��������� ��������� ��� �������� (���� ������ �����������)
 
DELETE FROM vk.messages 
 WHERE created_at > NOW();
  
 