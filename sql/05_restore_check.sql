-- 05: проверка восстановления из дампа (импорт выполнен в restore_test)
SELECT COUNT(*) AS users_rows FROM restore_test.users;
SELECT COUNT(*) AS orders_rows FROM restore_test.orders;
SELECT id, name, email FROM restore_test.users ORDER BY id;
