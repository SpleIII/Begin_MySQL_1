-- 06: демонстрация SET SESSION sql_log_off
SET SESSION sql_log_off = ON;
SELECT 'SQL_LOG_OFF_ON_MARKER' AS marker;

SET SESSION sql_log_off = OFF;
SELECT 'SQL_LOG_OFF_OFF_MARKER' AS marker;
