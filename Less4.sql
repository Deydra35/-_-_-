-- ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

SELECT DISTINCT firstname 
FROM vk.users 
ORDER BY firstname; 

-- Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

ALTER TABLE vk.profiles ADD COLUMN is_active tinyint(1) NOT NULL DEFAULT '1';

UPDATE vk.profiles 
SET is_active = 0
WHERE (
    (YEAR(CURRENT_DATE) - YEAR(birthday)) -                             
    (DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(birthday, '%m%d')) 
  ) < 18;
 
 -- Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)
 
DELETE FROM vk.messages 
 WHERE created_at > NOW();
  
 