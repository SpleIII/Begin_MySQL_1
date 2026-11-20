-- 06_covering_index.sql
USE index_practice;

CREATE INDEX idx_customer_amount
    ON orders(customer_id, amount);

EXPLAIN SELECT customer_id, SUM(amount)
FROM orders
GROUP BY customer_id;
