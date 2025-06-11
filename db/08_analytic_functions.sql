-- ==============================
-- Funcții ANALITICE (fără ROW_NUMBER)
-- ==============================

-- Ore cumulative per angajat
SELECT 
  employee_id,
  work_date,
  hours_worked,
  SUM(hours_worked) OVER (
    PARTITION BY employee_id 
    ORDER BY work_date
  ) AS cumulative_hours
FROM Timesheets
ORDER BY employee_id, work_date;

