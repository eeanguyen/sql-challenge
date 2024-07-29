# sql-challenge

## Background
It’s been two weeks since you were hired as a new data engineer at Pewlett Hackard (a fictional company). Your first major task is to do a research project about people whom the company employed during the 1980s and 1990s. All that remains of the employee database from that period are six CSV files.

For this project, you’ll design the tables to hold the data from the CSV files, import the CSV files into a SQL database, and then answer questions about the data. That is, you’ll perform data modeling, data engineering, and data analysis, respectively.

---
## Overview
This repository contains the implementation of an Employee Management System using PostgreSQL as the database backend. The system includes tables for managing employee data, department assignments, department management, salaries, and titles.

My process for analyzing the data was as follows:

- Data Modeling[#Data-Modeling]: Create a physical data model Entity Relationship Diagram (ERD) using QuickDBD of the 5 CSV files provided.
- Data Engineering[#Data-Engineering]: Designed and implemented a data base schema to manage employee data efficiently. In order to do this:

              - Mocked up schema
              - Imported table creation schema from prepopulated export in QuickDBD
              - Imported CSV files to their according table
- Data Analysis[#Data-Analysis]: Wrote query codes in PostgreSQL to answer questions asked through the module.
---
# Date Modeling

![QuickDBD_ERD_code](https://github.com/eeanguyen/sql-challenge/blob/main/EmployeeSQL/ERD_images/QuickDBD_ERD_code.jpg)

I inspected the CSV files, and then sketched an Entity Relationship Diagram of the tables and their relationships. I used QuickDBD to create a mock up of an ERD schema code

![QUICKDBD_ERD_Visual](https://github.com/eeanguyen/sql-challenge/blob/main/EmployeeSQL/ERD_images/QUICKDBD_ERD_Visual.jpg)

It then populated the Physical data model ERD above.

# Data Engineering

Below is a detailed schema for each of the six CSV files, specifying data types, primary keys, foreign keys, and other constraints. The order of table creation ensures that foreign keys are correctly referenced. I utilized the QuickDBD export as an outline for building these tables in PostgreSQL

```{r Table Creaion}
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
```
From the exported outline schema from QuickDBD were ALTER TABLE CONSTRAINTS for the foreign keys and their references to ensure that the data was consistent.

```{ALTER TABLE CONSTRAINT CODES}
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
```

# Data Analysis
As part of this project, I used SQL queries to answer a variety of straightforward questions about the data. This involved writing and executing SQL statements to extract meaningful insights and information from the database. Here are some examples of the types of questions addressed and the corresponding SQL queries used:

1. List the employee number, last name, first name, sex, and salary of each employee.
   ```{Question 1}
   SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
    FROM employees AS e
    JOIN salaries AS s
    ON e.emp_no = s.emp_no;
    ```
2. List the first name, last name, and hire date for the employees who were hired in 1986.
   ```{Question 2}
   SELECT first_name, last_name, hire_date
    FROM employees
    WHERE hire_date 
    BETWEEN '01/01/1986' AND '12/31/1986'
    	ORDER BY hire_date;
     ```
3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
   ```{Question 3}
   SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
    FROM dept_manager AS dm
    JOIN employees AS e
    ON dm.emp_no = e.emp_no
    JOIN departments AS d
    ON d.dept_no = dm.dept_no;
    ```
4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
   ```{Question 4}
   SELECT dem.dept_no, dem.emp_no, e.last_name, e.first_name, d.dept_name
    FROM dept_emp AS dem
    JOIN employees AS e
    ON dem.emp_no = e.emp_no
    JOIN departments AS d
    ON d.dept_no = dem.dept_no;
    ```
5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
    ```{Question 5}
    SELECT *
    FROM employees
    WHERE first_name = 'Hercules'
    AND last_name like 'B%';
    ```
6. List each employee in the Sales department, including their employee number, last name, and first name.
   ```{Question 6}
   SELECT d.dept_name, dem.emp_no, e.last_name, e.first_name
    FROM employees AS e
    JOIN dept_emp AS dem
    ON e.emp_no = dem.emp_no
    JOIN departments d
    ON d.dept_no = dem.dept_no
    WHERE d.dept_name = 'Sales';
    ```
7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
   ```{Question 7}
   SELECT d.dept_name, dem.emp_no, e.last_name, e.first_name
    FROM employees AS e
    JOIN dept_emp AS dem
    ON e.emp_no = dem.emp_no
    JOIN departments d
    ON d.dept_no = dem.dept_no
    WHERE d.dept_name = 'Sales'
    OR d.dept_name = 'Development'
    	ORDER BY d.dept_name;
     ```
8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
   ```
   SELECT last_name,
    COUNT(last_name) AS "Total Shared Last Names"
    FROM employees
    GROUP BY last_name
    ORDER BY COUNT(last_name) DESC;
   ```

