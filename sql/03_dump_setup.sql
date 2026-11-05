-- 03: база sql_practice для дампа (имя БД взято из команды mysqldump в задании)
CREATE DATABASE sql_practice
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sql_practice;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (name, email) VALUES
  ('Иван Петров',   'ivan@example.com'),
  ('Мария Сидорова', 'maria@example.com'),
  ('Павел Иванов',  'pavel@example.com'),
  ('Марк Аврелий',  'mark@example.com'),
  ('Vasya',         'vasya@example.com');

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO orders (user_id, amount) VALUES
  (1, 1500.00),
  (2, 320.50),
  (1, 99.99);

SELECT * FROM users;
SELECT * FROM orders;

SHOW TABLES;
