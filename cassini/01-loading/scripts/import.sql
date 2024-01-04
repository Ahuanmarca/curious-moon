-- 
-- CREATING IMPORT SCHEMA
-- Schema created in it's own namespace, not in the public schema
-- Will contain all values from master_plan.csv as strings

drop table if exists import.master_plan cascade;
drop schema if exists import cascade;

create schema if not exists import;
create table import.master_plan(
    start_time_utc text,
    duration text,
    date text,
    team text,
    spass_type text,
    target text,
    request_name text,
    library_definition text,
    title text,
    description text
);

-- Append to build.sql
-- In Windows (ps1 script)
-- \copy import.master_plan FROM '$CSV' WITH DELIMITER ',' HEADER CSV;
-- In Linux / macOS (Makefile)
-- COPY import.master_plan FROM $(CSV) WITH DELIMITER ',' HEADER CSV;
-- Note: COPY needs more permissions than \copy
-- --------