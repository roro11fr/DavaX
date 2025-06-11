-- ==============================
-- VIEW-uri
-- ==============================

-- Total ore per angajat
CREATE OR REPLACE VIEW vw_employee_total_hours AS
SELECT 
  e.employee_id,
  e.first_name || ' ' || e.last_name AS full_name,
  SUM(t.hours_worked) AS total_hours
FROM Employees e
JOIN Timesheets t ON e.employee_id = t.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;

-- Total ore per proiect
CREATE OR REPLACE VIEW vw_project_activity AS
SELECT 
  p.project_id,
  p.name AS project_name,
  COUNT(t.timesheet_id) AS total_entries,
  SUM(t.hours_worked) AS total_hours
FROM Projects p
LEFT JOIN Timesheets t ON p.project_id = t.project_id
GROUP BY p.project_id, p.name;

-- Ore lucrate pe zi (toți angajații și proiectele)
CREATE OR REPLACE VIEW vw_daily_summary AS
SELECT 
  work_date,
  COUNT(*) AS total_entries,
  SUM(hours_worked) AS total_hours,
  ROUND(AVG(hours_worked), 2) AS avg_hours
FROM Timesheets
GROUP BY work_date
ORDER BY work_date;
