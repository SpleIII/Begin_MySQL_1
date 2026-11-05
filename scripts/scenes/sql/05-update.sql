USE my_database;

UPDATE users SET name = 'Иван Петров' WHERE id = 1;
UPDATE users SET name = 'Vasya' WHERE id = 1;

SELECT * FROM users;
SELECT name, email FROM users WHERE id = 1;

SELECT * FROM users WHERE id = 1\G
