USE my_database;

INSERT INTO users (name, email) VALUES ('Павел Иванов', 'pavel@example.com');
INSERT INTO users (name, email) VALUES ('Марк Аврелий', 'mark@example.com');

SELECT name, HEX(name) FROM users WHERE id = 1;

SELECT * FROM users;
