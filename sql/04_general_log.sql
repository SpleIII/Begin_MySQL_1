-- 04: журнал general_log
-- ВАЖНО: при log_output = FILE таблица mysql.general_log пуста,
-- поэтому сначала включаем вывод ещё и в таблицу.
SET GLOBAL log_output = 'FILE,TABLE';

-- В MySQL 8.4 значение user_host имеет вид: root[root] @ localhost [::1],
-- поэтому шаблон 'root@%' из методички не срабатывает — используем 'root%'.
SELECT event_time, command_type, argument
FROM mysql.general_log
WHERE user_host LIKE 'root%'
  AND argument NOT LIKE '--%'
ORDER BY event_time DESC
LIMIT 15;

-- то же, но без служебного шума клиента и без комментариев скрипта
SELECT event_time, command_type, argument
FROM mysql.general_log
WHERE user_host LIKE 'root%'
  AND argument NOT LIKE '--%'
  AND argument NOT LIKE 'SET NAMES%'
  AND argument NOT LIKE 'SHOW VARIABLES%'
  AND argument NOT LIKE 'SELECT @@%'
  AND argument NOT LIKE 'SET SESSION sql_log_off%'
ORDER BY event_time DESC
LIMIT 15;

-- возвращаем исходный режим из my.cnf
SET GLOBAL log_output = 'FILE';
