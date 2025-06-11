-- ==============================
-- SELECT-uri cu GROUP BY
-- ==============================

-- Ore lucrate per angajat (ordine crescătoare)
SELECT 
  e.employee_id, 
  SUM(t.hours_worked) AS total_hours
FROM Employees e
JOIN Timesheets t ON e.employee_id = t.employee_id
GROUP BY e.employee_id
ORDER BY total_hours;

-- Taskuri per tip
SELECT 
  tt.name AS task_type,
  COUNT(*) AS total_tasks
FROM Timesheets t
JOIN Task_Types tt ON t.task_type_id = tt.task_type_id
GROUP BY tt.name
ORDER BY total_tasks DESC;

-- Număr angajați per lună de angajare
SELECT 
  TRUNC(hire_date, 'MM') AS hire_month,
  COUNT(*) AS total_hired
FROM Employees
GROUP BY TRUNC(hire_date, 'MM')
ORDER BY hire_month;
