-- 07_explain_analyze.sql
USE index_practice;

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE amount > 1000;
