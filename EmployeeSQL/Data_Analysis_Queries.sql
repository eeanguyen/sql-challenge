-- Drop Tables if Existing for fresh start
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- Create Tables that were populated from QuickDBD
CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" VARCHAR(20)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(20)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(20)   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title" VARCHAR(5)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(20)   NOT NULL,
    "last_name" VARCHAR(20)   NOT NULL,
    "sex" VARCHAR(5)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(20)   NOT NULL,
    "title" VARCHAR(20)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

-- Run ALTER TABLE functions AFTER importing the CSVs or else will run into error when importing
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Query ALL * from tables to ensure CSVs are imported

SELECT *
FROM departments;

SELECT *
FROM dept_emp;

SELECT *
FROM dept_manager;

SELECT *
FROM employees;

SELECT *
FROM salaries;

SELECT *
FROM titles;


-- Queries
	
-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
JOIN salaries AS s
ON e.emp_no = s.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date 
BETWEEN '01/01/1986' AND '12/31/1986'
	ORDER BY hire_date;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_manager AS dm
JOIN employees AS e
ON dm.emp_no = e.emp_no
JOIN departments AS d
ON d.dept_no = dm.dept_no;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT dem.dept_no, dem.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp AS dem
JOIN employees AS e
ON dem.emp_no = e.emp_no
JOIN departments AS d
ON d.dept_no = dem.dept_no;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT *
FROM employees
WHERE first_name = 'Hercules'
AND last_name like 'B%';


-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT d.dept_name, dem.emp_no, e.last_name, e.first_name
FROM employees AS e
JOIN dept_emp AS dem
ON e.emp_no = dem.emp_no
JOIN departments d
ON d.dept_no = dem.dept_no
WHERE d.dept_name = 'Sales';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT d.dept_name, dem.emp_no, e.last_name, e.first_name
FROM employees AS e
JOIN dept_emp AS dem
ON e.emp_no = dem.emp_no
JOIN departments d
ON d.dept_no = dem.dept_no
WHERE d.dept_name = 'Sales'
OR d.dept_name = 'Development'
	ORDER BY d.dept_name;

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name,
COUNT(last_name) AS "Total Shared Last Names"
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;