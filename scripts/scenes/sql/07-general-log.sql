-- Для скриншота: включаем вывод журнала и в таблицу, чтобы показать записи из методички
SET GLOBAL log_output = 'FILE,TABLE';

USE sql_practice;
SELECT COUNT(*) AS users_count FROM users;
SELECT 'mysql works' AS note;

SELECT event_time,
       command_type,
       LEFT(REPLACE(argument, CHAR(10), ' '), 45) AS argument
FROM mysql.general_log
WHERE user_host LIKE 'root%'
  AND argument NOT LIKE '--%'
  AND argument NOT LIKE '%general_log%'
  AND event_time > NOW() - INTERVAL 30 MINUTE
ORDER BY event_time DESC
LIMIT 5;

SET GLOBAL log_output = 'FILE';
