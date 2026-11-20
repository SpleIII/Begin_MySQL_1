-- 02_explain_before.sql
USE index_practice;

SHOW INDEX FROM orders;
EXPLAIN SELECT * FROM orders WHERE amount > 1000;
