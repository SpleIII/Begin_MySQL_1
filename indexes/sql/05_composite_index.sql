-- 05_composite_index.sql
USE index_practice;

CREATE INDEX idx_status_amount
    ON orders(status, amount);

SHOW INDEX FROM orders;

EXPLAIN SELECT * FROM orders WHERE status = 'paid';
EXPLAIN SELECT * FROM orders
WHERE status = 'paid' AND amount > 1000;

DROP INDEX idx_amount ON orders;
EXPLAIN SELECT * FROM orders WHERE amount > 1000;
CREATE INDEX idx_amount ON orders(amount);
