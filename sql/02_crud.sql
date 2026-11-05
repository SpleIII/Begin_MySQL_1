-- 02: CRUD-операции, удаление таблицы и базы
USE my_database;

-- 4. Вставка данных
SELECT * FROM users;

INSERT INTO users (name, email) VALUES ('Павел Иванов', 'pavel@example.com');
INSERT INTO users (name, email) VALUES ('Марк Аврелий', 'mark@example.com');

-- проверка кодировки: кириллица в HEX (Иван -> D0 98 D0 B2 D0 B0 D0 BD)
SELECT name, HEX(name) FROM users WHERE id = 1;

-- 5. Просмотр данных
SELECT * FROM users;

-- 6. Обновление данных
UPDATE users SET name = 'Иван Петров' WHERE id = 1;
UPDATE users SET name = 'Vasya' WHERE id = 1;

SELECT * FROM users;
SELECT * FROM users WHERE id = 1;
SELECT name, email FROM users;
SELECT name FROM users;
SELECT name, email FROM users WHERE id = 1;

-- удобный вертикальный вывод (\G заменяет ;)
SELECT * FROM users WHERE id = 1\G

-- 7. Удаление данных
SELECT * FROM users;

DELETE FROM users WHERE id = 2;

SELECT * FROM users;

-- 8. Удаление таблицы
DROP TABLE users;
SHOW TABLES;

-- 9. Удаление базы данных
DROP DATABASE my_database;
SHOW DATABASES;
