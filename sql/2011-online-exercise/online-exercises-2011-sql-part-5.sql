-- 1). Display department name and number of employees in the department ? 
DESCRIBE departments;
SELECT * FROM departments;

SELECT d.department_name, COUNT(*) AS num_of_employees
FROM employees e NATURAL JOIN departments d 
GROUP BY d.department_name;

SELECT d.department_name, COUNT(e.employee_id) AS num_of_employees
FROM employees e NATURAL JOIN departments d 
GROUP BY d.department_name;

SELECT d.department_name, COUNT(e.employee_id) AS num_of_employees
FROM employees e INNER JOIN departments d 
ON e.manager_id = d.manager_id
GROUP BY d.department_name;

SELECT d.department_name, COUNT(e.employee_id) AS num_of_employees
FROM employees e INNER JOIN departments d 
ON e.employee_id = d.manager_id
GROUP BY d.department_name;

-- 2). Display job title, employee ID, number of days between ending date and starting date for all jobs in department 30 from job history ?
SELECT * FROM job_history;

SELECT j.job_title, jh.employee_id, EXTRACT(DAY FROM jh.end_date - EXTRACT(DAY FROM jh.start_date)) AS num_of_days
FROM jobs j INNER JOIN job_history jh
ON jh.job_id = j.job_id
WHERE department_id = 30;

SELECT employee_id, job_title, end_date-start_date DAYS 
FROM job_history NATURAL JOIN jobs 
WHERE department_id=30;

-- 3). Display department name and manager first name ?
SELECT * FROM departments;

SELECT d.department_name, e.first_name
FROM departments d, employees e
WHERE d.manager_id = e.employee_id;

SELECT d.department_name, e.first_name 
FROM departments d INNER JOIN employees e 
ON d.manager_id = e.employee_id;

-- 4). Display department name, manager name, and city ?
SELECT d.department_name, e.first_name || ' ' || e.last_name AS manager, l.city 
FROM departments d INNER JOIN employees e 
ON d.manager_id = e.employee_id
INNER JOIN locations l
ON d.location_id = l.location_id;

SELECT d.department_name, e.first_name || ' ' || e.last_name AS manager, l.city 
FROM departments d INNER JOIN employees e 
ON (d.manager_id = e.employee_id) 
INNER JOIN locations l 
USING (location_id);

-- 5). Display country name, city, and department name ?
SELECT c.country_name, l.city, d.department_name
FROM departments d INNER JOIN locations l
ON d.location_id = l.location_id
INNER JOIN countries c
ON l.country_id = c.country_id;

SELECT c.country_name, l.city, d.department_name 
FROM countries c JOIN locations l
USING (country_id) 
JOIN departments d
USING (location_id);

-- 6). Display job title, department name, employee last name, starting date for all jobs from 2000 to 2005 ?
SELECT j.job_title, d.department_name, e.last_name, e.hire_date
FROM employees e INNER JOIN jobs j
ON e.job_id = j.job_id
INNER JOIN departments d
ON e.employee_id = d.department_id
WHERE EXTRACT(YEAR FROM e.hire_date) BETWEEN 2000 AND 2005;

SELECT j.job_title, d.department_name, e.last_name, jh.start_date
FROM job_history jh INNER JOIN jobs j
ON jh.job_id = j.job_id
INNER JOIN departments d
ON jh.department_id = d.department_id
INNER JOIN employees e
ON d.department_id = e.department_id
WHERE EXTRACT(YEAR FROM jh.start_date) BETWEEN 2000 AND 2005;

SELECT job_title, department_name, last_name, start_date 
FROM job_history JOIN jobs USING (job_id) 
JOIN departments USING (department_id) 
JOIN  employees USING (employee_id) 
WHERE TO_CHAR(start_date,'YYYY') BETWEEN 2000 AND 2005;

-- 7). Display job title and average salary of employees ?
SELECT job_title, AVG(min_salary + max_salary) AS average_emp_salary
FROM jobs
GROUP BY job_title
ORDER BY average_emp_salary DESC; --ASC;

SELECT job_title, AVG(salary) AS average_emp_salary
FROM employees e INNER JOIN jobs j
ON e.job_id = j.job_id
GROUP BY job_title
ORDER BY average_emp_salary DESC; --ASC;

-- 8). Display job title, employee name, and the difference between maximum salary for the job and salary of the employee ?
SELECT job_title, first_name, max_salary-salary as diff_between_sal_and_maxSal
FROM employees e INNER JOIN jobs j
ON e.job_id = j.job_id;

SELECT job_title, first_name, max_salary-salary as difference 
FROM employees NATURAL JOIN jobs;

-- 9). Display last name, job title of employees who have commission percentage and belongs to department 30 ? 
SELECT last_name, job_title, d.department_id, commission_pct
FROM employees e, departments d, jobs j
ORDER BY d.department_id;

SELECT last_name, job_title, department_id, commission_pct
FROM employees e, jobs j
WHERE commission_pct IS NOT NULL
AND department_id = 30
ORDER BY department_id;

SELECT last_name, job_title, d.department_id, commission_pct
FROM employees e, departments d, jobs j
WHERE commission_pct IS NOT NULL
AND d.department_id = 30
ORDER BY d.department_id;

SELECT last_name, job_title
FROM employees e INNER JOIN jobs j 
ON e.job_id = j.job_id
INNER JOIN departments d
ON e.department_id = d.department_id 
WHERE commission_pct IS NOT NULL
AND d.department_id = 30
ORDER BY d.department_id;

SELECT last_name, job_title
FROM employees NATURAL JOIN jobs 
NATURAL JOIN departments
WHERE commission_pct IS NOT NULL
AND department_id = 30
ORDER BY department_id;

-- 10). Display details of jobs that were done by any employee who is currently drawing more than 15000 of salary ?
SELECT job_title, min_salary, max_salary 
FROM JOBS j INNER JOIN employees e
ON j.job_id = e.job_id
WHERE e.salary > 15000;

SELECT jh.*
FROM  job_history jh JOIN employees e 
ON jh.employee_id = e.employee_id
WHERE salary > 15000;

SELECT j.job_title, j.min_salary, j.max_salary, jh.employee_id, jh.start_date, jh.end_date, jh.job_id, jh.department_id
FROM JOBS j INNER JOIN employees e
ON j.job_id = e.job_id
INNER JOIN job_history jh
ON e.employee_id = jh.employee_id 
WHERE e.salary > 15000
ORDER BY jh.start_date;

-- Revisit query I couldn't solve earlier. I think I have a solution Update instead of Delete 30-04-2017
