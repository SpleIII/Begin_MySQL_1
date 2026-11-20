-- 03_explain_after_amount.sql
USE index_practice;

CREATE INDEX idx_amount ON orders(amount);
SHOW INDEX FROM orders;
EXPLAIN SELECT * FROM orders WHERE amount > 1000;
