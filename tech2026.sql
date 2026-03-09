CREATE DATABASE IF NOT EXISTS tech_company CHARACTER SET utf8;
USE tech_company;

DROP TABLE IF EXISTS employees_leaders;
DROP TABLE IF EXISTS leaders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Department table
CREATE TABLE departments(
                            department_number INT PRIMARY KEY,
                            department_name VARCHAR(30),
                            office_location VARCHAR(30)
);

-- Employee table
CREATE TABLE employees(
                          employee_number INT PRIMARY KEY,
                          employee_name VARCHAR(30),
                          job_title VARCHAR(30),
                          manager_id INT,
                          hire_date DATE,
                          salary DECIMAL(10,2),
                          commission DECIMAL(10,2),
                          department_number INT,
                          FOREIGN KEY (department_number)
                              REFERENCES departments(department_number)
);

-- Departments data
INSERT INTO departments VALUES
                            (10,'ACCOUNTING','NEW YORK'),
                            (20,'RESEARCH','DALLAS'),
                            (30,'SALES','CHICAGO'),
                            (40,'OPERATIONS','BOSTON');

-- Employees data
INSERT INTO employees VALUES
                          (7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
                          (7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30),
                          (7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30),
                          (7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20),
                          (7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
                          (7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
                          (7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10),
                          (7788,'SCOTT','ANALYST',7566,'1987-04-19',3000,NULL,20),
                          (7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,NULL),
                          (7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30),
                          (7876,'ADAMS','CLERK',7788,'1987-05-23',1100,NULL,20),
                          (7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30),
                          (7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,20),
                          (7934,'MILLER','CLERK',7782,'1982-01-23',1300,NULL,10);

-- Simple selections
SELECT employee_number
FROM employees
WHERE employee_name='MARTIN';

SELECT *
FROM employees
WHERE salary > 1500
ORDER BY salary DESC;

SELECT employee_name
FROM employees
WHERE job_title='SALESMAN'
  AND salary > 1300;

SELECT *
FROM employees
WHERE job_title <> 'SALESMAN';

-- Pattern search
SELECT employee_name
FROM employees
WHERE employee_name LIKE 'J%S';

SELECT employee_name
FROM employees
WHERE employee_name LIKE 'J%S'
  AND job_title='MANAGER';

-- Department queries
SELECT department_name
FROM departments
WHERE office_location='NEW YORK';

SELECT *
FROM departments
ORDER BY office_location;

-- Aggregate functions
SELECT COUNT(*) AS total_employees
FROM employees;

SELECT SUM(salary) AS total_salary
FROM employees;

SELECT AVG(salary) AS average_salary
FROM employees
WHERE department_number=20;

SELECT DISTINCT job_title
FROM employees;

SELECT department_number, COUNT(*) AS employees_in_department
FROM employees
GROUP BY department_number;

SELECT SUM(salary + IFNULL(commission,0)) AS total_payment
FROM employees;

-- Subquery example
SELECT employee_name, salary
FROM employees
WHERE salary >
      (
          SELECT AVG(salary)
          FROM employees
      );

-- JOIN examples
SELECT *
FROM employees e
         INNER JOIN departments d
                    ON e.department_number = d.department_number;

SELECT e.employee_name, d.department_name
FROM employees e
         INNER JOIN departments d
                    ON e.department_number = d.department_number
ORDER BY e.employee_name;

SELECT e.employee_name, d.department_name
FROM employees e
         LEFT JOIN departments d
                   ON e.department_number = d.department_number;

SELECT d.department_name, COUNT(e.employee_number)
FROM departments d
         LEFT JOIN employees e
                   ON d.department_number = e.department_number
GROUP BY d.department_name;

SELECT department_number, COUNT(*) AS number_of_employees
FROM employees
GROUP BY department_number
HAVING COUNT(*) > 3;

-- Leaders
CREATE TABLE leaders(
                        leader_number INT PRIMARY KEY,
                        leader_name VARCHAR(30)
);

CREATE TABLE employees_leaders(
                                  employee_number INT,
                                  leader_number INT,
                                  PRIMARY KEY(employee_number,leader_number),
                                  FOREIGN KEY(employee_number) REFERENCES employees(employee_number),
                                  FOREIGN KEY(leader_number) REFERENCES leaders(leader_number)
);

INSERT INTO leaders VALUES
                        (1,'TEAM_LEAD_A'),
                        (2,'TEAM_LEAD_B');

INSERT INTO employees_leaders VALUES
                                  (7369,1),
                                  (7499,1),
                                  (7521,2);

-- Final relation query
SELECT e.employee_name, l.leader_name
FROM employees e
         JOIN employees_leaders el ON e.employee_number = el.employee_number
         JOIN leaders l ON el.leader_number = l.leader_number;

COMMIT;