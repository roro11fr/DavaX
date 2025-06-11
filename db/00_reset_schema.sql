-- ==============================
-- RESET: Ștergere completă a obiectelor din schema DAVAX_DEV
-- ==============================

---- 1. DROP INDEX-uri (înainte de tabele)
--DROP INDEX idx_project;
--DROP INDEX idx_lower_email;
--DROP INDEX idx_timesheets_employee_date;
--
--
---- 2. DROP TRIGGER
--DROP TRIGGER trg_timesheet_workdate_check;
--DROP TRIGGER trg_grant_read_only_role;
--
---- 3. DROP MATERIALIZED VIEW-uri
--DROP MATERIALIZED VIEW my_rejected_tasks_per_employee;
--DROP MATERIALIZED VIEW total_hours_employee_per_month;
--DROP MATERIALIZED VIEW mv_remote_vs_onsite;
--
---- 4. DROP VIEW-uri
--DROP VIEW vw_employee_total_hours;
--DROP VIEW vw_project_activity;
--DROP VIEW vw_daily_summary;
--
---- 5. DROP PROCEDURI
--DROP PROCEDURE insert_random_timesheets;
--
---- 6. DROP TABEL-e (în ordine inversă față de FK)
--DROP TABLE Timesheet_Audit CASCADE CONSTRAINTS PURGE;
--DROP TABLE Timesheets CASCADE CONSTRAINTS PURGE;
--DROP TABLE Task_Types CASCADE CONSTRAINTS PURGE;
--DROP TABLE Projects CASCADE CONSTRAINTS PURGE;
--DROP TABLE Employees CASCADE CONSTRAINTS PURGE;
--
---- 7. DROP ROLE + USERS
--DROP ROLE read_only_role;
--DROP USER davax_read CASCADE;
--DROP USER davax_dev CASCADE;



DROP USER davax_dev CASCADE;

 DROP TABLESPACE davax_data INCLUDING CONTENTS AND DATAFILES;
 DROP TABLESPACE davax_index INCLUDING CONTENTS AND DATAFILES;
 DROP TABLESPACE davax_partition INCLUDING CONTENTS AND DATAFILES;
 DROP TABLESPACE davax_archive INCLUDING CONTENTS AND DATAFILES;
 DROP TABLESPACE davax_audit INCLUDING CONTENTS AND DATAFILES;






-- ==============================
-- 1. TABLESPACES
-- ==============================


CREATE TABLESPACE davax_data
DATAFILE 'davax_data_v2.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M EXTENT MANAGEMENT LOCAL;

CREATE TABLESPACE davax_index
DATAFILE 'davax_index_v2.dbf' SIZE 50M AUTOEXTEND ON NEXT 5M EXTENT MANAGEMENT LOCAL;

CREATE TABLESPACE davax_partition
DATAFILE 'davax_partition_v2.dbf' SIZE 200M AUTOEXTEND ON NEXT 20M EXTENT MANAGEMENT LOCAL;

CREATE TABLESPACE davax_archive
DATAFILE 'davax_archive_v2.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M EXTENT MANAGEMENT LOCAL;

CREATE TABLESPACE davax_audit
DATAFILE 'davax_audit_v2.dbf' SIZE 50M AUTOEXTEND ON NEXT 5M EXTENT MANAGEMENT LOCAL;





-- ==============================
-- 2. USERS
-- ==============================

CREATE USER davax_dev IDENTIFIED BY dev_pass
DEFAULT TABLESPACE davax_data TEMPORARY TABLESPACE temp;

GRANT CONNECT, RESOURCE TO davax_dev;

ALTER USER davax_dev QUOTA UNLIMITED ON davax_data;
ALTER USER davax_dev QUOTA UNLIMITED ON davax_index;
ALTER USER davax_dev QUOTA UNLIMITED ON davax_partition;
ALTER USER davax_dev QUOTA UNLIMITED ON davax_archive;
ALTER USER davax_dev QUOTA UNLIMITED ON davax_audit;


-- ==============================
-- 3.PERMISIUNI
-- ==============================


GRANT CREATE VIEW TO davax_dev;
GRANT CREATE MATERIALIZED VIEW TO davax_dev;

