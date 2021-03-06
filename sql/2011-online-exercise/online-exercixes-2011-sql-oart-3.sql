-- 1). Display the number of days between system date and 1st January 2011 ? 
SELECT EXTRACT(DAY FROM (SYSDATE - CAST(TO_DATE('1.1.' || 2011, 'DD.MM.YYYY') AS TIMESTAMP ))) AS DAYS_BETWEEN_TWO_DATES FROM DUAL;
SELECT EXTRACT(DAY FROM SYSDATE - CAST(DATE '2011-01-01' AS TIMESTAMP)) AS DAYS_BETWEEN_TWO_DATES FROM DUAL;
SELECT SYSDATE - to_date('01-jan-2011') AS DAYS_BETWEEN_TWO_DATES FROM DUAL;

-- 2). Display how many employees joined in each month of the current year ?
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;

SELECT HIRE_DATE, EXTRACT(MONTH FROM HIRE_DATE) AS HIRE_MONTH
FROM EMPLOYEES
WHERE EXTRACT(YEAR FROM HIRE_DATE) = '2007' --EXTRACT(YEAR FROM SYSDATE)
ORDER BY HIRE_MONTH DESC;

SELECT EXTRACT(MONTH FROM HIRE_DATE) AS HIRE_MONTH, COUNT(EXTRACT(MONTH FROM HIRE_DATE)) AS COUNT_NEW_HIRES_PER_MONTH
FROM EMPLOYEES
WHERE EXTRACT(YEAR FROM HIRE_DATE) = '2007' --EXTRACT(YEAR FROM SYSDATE)
GROUP BY EXTRACT(MONTH FROM HIRE_DATE)
ORDER BY HIRE_MONTH DESC;

SELECT TO_CHAR(HIRE_DATE,'MM') AS HIRE_MONTH, COUNT (*) AS NEW_HIRES_PER_MONTH
FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE,'YYYY')= '2007' --TO_CHAR(SYSDATE,'YYYY') 
GROUP BY TO_CHAR(HIRE_DATE,'MM')
ORDER BY HIRE_MONTH;

-- 3). Display manager ID and number of employees managed by the manager ?
SELECT e.EMPLOYEE_ID, e.MANAGER_ID
FROM EMPLOYEES e;

SELECT d.MANAGER_ID
FROM DEPARTMENTS d;

SELECT COUNT(e.EMPLOYEE_ID) AS EMPLOYEES_PER_MANAGER, e.MANAGER_ID AS SOLE_MANAGER
FROM EMPLOYEES e
GROUP BY e.MANAGER_ID
ORDER BY EMPLOYEES_PER_MANAGER DESC;

SELECT COUNT(e.EMPLOYEE_ID) AS EMPLOYEES_PER_MANAGER, e.MANAGER_ID AS SOLE_MANAGER
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d
ON e.EMPLOYEE_ID = d.MANAGER_ID
GROUP BY e.MANAGER_ID;

SELECT MANAGER_ID, COUNT(*) 
FROM EMPLOYEES 
GROUP BY MANAGER_ID;

-- 4). Display employee ID and the date on which he ended his previous job ? 
SELECT EMPLOYEE_ID, END_DATE 
FROM JOB_HISTORY
ORDER BY EMPLOYEE_ID;

SELECT EMPLOYEE_ID, MAX(END_DATE) 
FROM JOB_HISTORY 
GROUP BY EMPLOYEE_ID;

SELECT e.EMPLOYEE_ID, MAX(jh.END_DATE) AS END_DATE_OF_PREVIOUS_JOB
FROM EMPLOYEES e
INNER JOIN JOB_HISTORY jh
ON e.EMPLOYEE_ID = jh.EMPLOYEE_ID
GROUP BY e.EMPLOYEE_ID;

-- 5). Display number of employees joined after 15th of the month ?
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE
FROM EMPLOYEES
WHERE EXTRACT(DAY FROM HIRE_DATE) > 15;

SELECT COUNT(*)
FROM EMPLOYEES
WHERE EXTRACT(DAY FROM HIRE_DATE) > 15;

SELECT COUNT(*) 
FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE,'DD') >= 15;

-- 6). Display the country ID and number of cities we have in the country ?

    -- COUNT(*) counts all rows
    -- COUNT(column) counts non-NULLs only
    -- COUNT(1) is the same as COUNT(*) because 1 is a non-null expressions
    -- The use of COUNT(*) or COUNT(column) should be based on the desired output only

SELECT COUNTRY_ID, COUNT(CITY)
FROM LOCATIONS
GROUP BY COUNTRY_ID;

SELECT COUNTRY_ID,  COUNT(*)  
FROM LOCATIONS 
GROUP BY COUNTRY_ID;

SELECT c.COUNTRY_ID, COUNT(CITY) 
FROM COUNTRIES c
INNER JOIN LOCATIONS l ON
c.COUNTRY_ID = l.COUNTRY_ID
GROUP BY c.COUNTRY_ID;

-- 7). Display the average salary of employees, in each department, who have a commission percentage ? 
SELECT FIRST_NAME, LAST_NAME, AVG(SALARY)
FROM EMPLOYEES
GROUP BY FIRST_NAME, LAST_NAME;

SELECT COMMISSION_PCT
FROM EMPLOYEES;

SELECT e.FIRST_NAME, e.LAST_NAME, AVG(SALARY)
FROM EMPLOYEES e
WHERE e.COMMISSION_PCT IS NOT NULL
GROUP BY e.FIRST_NAME, e.LAST_NAME;

SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME, AVG(SALARY)
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.COMMISSION_PCT IS NOT NULL
GROUP BY e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME;

SELECT d.DEPARTMENT_NAME, AVG(SALARY)
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.COMMISSION_PCT IS NOT NULL
GROUP BY d.DEPARTMENT_NAME;

SELECT DEPARTMENT_ID, AVG(SALARY) 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL 
GROUP BY DEPARTMENT_ID;

-- 8). Display job ID, number of employees, sum of salary, and difference between highest salary and lowest salary of the employees of the job ?
SELECT e.JOB_ID, COUNT(e.EMPLOYEE_ID), SUM(e.SALARY) AS TOTAL_SALARY, SUM(j.MAX_SALARY - j.MIN_SALARY) AS SALARY_DIFFERENCE
FROM EMPLOYEES e
INNER JOIN JOBS j 
ON e.JOB_ID = j.JOB_ID
GROUP BY e.JOB_ID;

SELECT JOB_ID, COUNT(EMPLOYEE_ID) AS Number_Of_Employees, SUM(SALARY) AS Total_Salary, MAX(SALARY)-MIN(SALARY) AS Salary_Difference
FROM EMPLOYEES 
GROUP BY JOB_ID;

-- 9). Display job ID for jobs with average salary more than 10000 ?

-- To use aggregate functions (like SUM/AVERAGE etc.,) you need to group the results using the GROUP BY clause. 
-- To filter results based on the aggregation on a column, you should perform a GROUP BY on the selected columns, 
-- and then use the HAVING clause to specify the filter

SELECT e.JOB_ID, e.SALARY, av.Average_Salary
FROM (SELECT AVG(e.SALARY) AS Average_Salary
      FROM EMPLOYEES e
      GROUP BY e.JOB_ID) av, EMPLOYEES e
WHERE e.SALARY > av.Average_Salary;

SELECT JOB_ID, AVG(SALARY) 
FROM EMPLOYEES 
GROUP BY JOB_ID 
HAVING AVG(SALARY) > 10000;

-- 10). Display years in which more than 10 employees joined ? 
SELECT HIRE_DATE, MAX(EMPLOYEE_ID) AS COUNT_EMPLOYEES
FROM EMPLOYEES
GROUP BY HIRE_DATE
HAVING MAX(EMPLOYEE_ID) > 10
ORDER BY HIRE_DATE;

SELECT EXTRACT(YEAR FROM HIRE_DATE) AS MY_YEAR
FROM EMPLOYEES
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
HAVING COUNT(EMPLOYEE_ID) > 10
ORDER BY MY_YEAR;

SELECT TO_CHAR(HIRE_DATE,'YYYY') FROM EMPLOYEES 
GROUP BY TO_CHAR(HIRE_DATE,'YYYY') 
HAVING COUNT(EMPLOYEE_ID) > 10;
