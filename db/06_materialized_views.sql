-- ==============================
-- MATERIALIZED VIEW-uri
-- ==============================

-- Taskuri respinse per angajat/zi
CREATE MATERIALIZED VIEW my_rejected_tasks_per_employee
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH SYSDATE
NEXT SYSDATE + 1
AS
SELECT 
  employee_id,
  work_date,
  COUNT(*) AS rejected_tasks
FROM Timesheets
WHERE JSON_VALUE(notes, '$.approval') = 'rejected'
GROUP BY employee_id, work_date;

-- Ore lunare per angajat
CREATE MATERIALIZED VIEW total_hours_employee_per_month
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT 
  employee_id,
  TRUNC(work_date, 'MM') AS month,
  SUM(hours_worked) AS total_hours
FROM Timesheets
GROUP BY employee_id, TRUNC(work_date, 'MM');

-- Medie ore remote vs onsite
CREATE MATERIALIZED VIEW mv_remote_vs_onsite
BUILD IMMEDIATE
REFRESH COMPLETE
START WITH SYSDATE
NEXT SYSDATE + 1
AS
SELECT 
  JSON_VALUE(notes, '$.remote') AS remote_flag,
  COUNT(*) AS task_count,
  ROUND(AVG(hours_worked), 2) AS avg_hours
FROM Timesheets
GROUP BY JSON_VALUE(notes, '$.remote');
