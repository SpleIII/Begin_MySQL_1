-- 04_function_index.sql
USE index_practice;

EXPLAIN SELECT * FROM orders WHERE YEAR(order_date) = 2026;

CREATE INDEX idx_order_date ON orders(order_date);
SHOW INDEX FROM orders;

EXPLAIN SELECT * FROM orders
WHERE order_date >= '2026-01-01'
  AND order_date < '2027-01-01';
