-- ==============================
-- 8. INSERARE DATE
-- ==============================

-- 1. Employees – 1000 angajați
BEGIN
  FOR i IN 1..1000 LOOP
    INSERT INTO Employees (first_name, last_name, email)
    VALUES (
      'First_' || i,
      'Last_' || i,
      LOWER('user_' || i || '@davax.com')
    );
  END LOOP;
  COMMIT;
END;
/

-- 2. Projects – 20 proiecte
BEGIN
  FOR i IN 1..20 LOOP
    INSERT INTO Projects (name, description, start_date, end_date)
    VALUES (
      'Project_' || i,
      'Generated project ' || i,
      TRUNC(SYSDATE - DBMS_RANDOM.VALUE(100, 1000)),
      TRUNC(SYSDATE - DBMS_RANDOM.VALUE(10, 99))
    );
  END LOOP;
  COMMIT;
END;
/

-- 3. Task Types – 10 tipuri
BEGIN
  FOR i IN 1..10 LOOP
    INSERT INTO Task_Types (name, description)
    VALUES (
      'TaskType_' || i,
      'Task type generated ' || i
    );
  END LOOP;
  COMMIT;
END;
/

-- 4. Procedura pentru Timesheets
-- 10 000 mii inregistrari pentru TImesheets







CREATE OR REPLACE PROCEDURE insert_random_timesheets(p_count NUMBER DEFAULT 1000) AS
BEGIN
  FOR i IN 1..p_count LOOP
    DECLARE
      v_employee_id  Employees.employee_id%TYPE;
      v_project_id   Projects.project_id%TYPE;
      v_task_type_id Task_Types.task_type_id%TYPE;

      v_work_date    DATE;
      v_hours        NUMBER(4,2);

      v_task_name    VARCHAR2(50);
      v_emp_name     VARCHAR2(100);
      v_project_name VARCHAR2(100);
      v_remote       VARCHAR2(5);
      v_approval     VARCHAR2(10);
      v_start_time   VARCHAR2(5);
      v_end_time     VARCHAR2(5);
      v_json         CLOB;
    BEGIN
      -- Select random IDs & names
      SELECT employee_id INTO v_employee_id FROM (
        SELECT employee_id FROM Employees ORDER BY DBMS_RANDOM.VALUE
      ) WHERE ROWNUM = 1;

      SELECT project_id, name INTO v_project_id, v_project_name FROM (
        SELECT project_id, name FROM Projects ORDER BY DBMS_RANDOM.VALUE
      ) WHERE ROWNUM = 1;

      SELECT task_type_id, name INTO v_task_type_id, v_task_name FROM (
        SELECT task_type_id, name FROM Task_Types ORDER BY DBMS_RANDOM.VALUE
      ) WHERE ROWNUM = 1;

      SELECT first_name || ' ' || last_name INTO v_emp_name
      FROM Employees WHERE employee_id = v_employee_id;

      -- Generate data
      v_work_date := TRUNC(SYSDATE - DBMS_RANDOM.VALUE(1, 60));
      v_hours := ROUND(DBMS_RANDOM.VALUE(1, 8), 2);
      v_remote := CASE TRUNC(DBMS_RANDOM.VALUE(0, 2)) WHEN 1 THEN 'true' ELSE 'false' END;
      v_approval := CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))
                      WHEN 1 THEN 'approved'
                      WHEN 2 THEN 'pending'
                      ELSE 'rejected'
                    END;
      v_start_time := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(8, 11))) || ':00';
      v_end_time := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(16, 19))) || ':00';

      -- Construct JSON
      v_json := '{' ||
                '"note": "' || v_task_name || '", ' ||
                '"employee": "' || v_emp_name || '", ' ||
                '"project": "' || v_project_name || '", ' ||
                '"remote": ' || v_remote || ', ' ||
                '"approval": "' || v_approval || '", ' ||
                '"duration": { "start": "' || v_start_time || '", "end": "' || v_end_time || '" }' ||
                '}';

      -- Insert
      INSERT INTO Timesheets (
        employee_id, project_id, task_type_id, work_date, hours_worked, notes
      )
      VALUES (
        v_employee_id, v_project_id, v_task_type_id, v_work_date, v_hours, v_json
      );
    END;
  END LOOP;
  COMMIT;
END insert_random_timesheets;
/


BEGIN
  insert_random_timesheets(1000);
END;
/

