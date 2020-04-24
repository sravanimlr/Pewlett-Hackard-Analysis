-- CHALLENGE TABLE 1
--Challenge Table 1(using INTO METHOD) Number of Retiring Employees by Title 
SELECT e.emp_no,
e.first_name,
e.last_name,
de.from_date,
s.salary,
s.to_date,
ti.title
INTO retiring_employees_by_title 
FROM employees as e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_manager as de
		ON (de.from_date = s.from_date)
	INNER JOIN titles as ti
		ON (e.emp_no = ti.emp_no)
ORDER BY e.emp_no;


-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 to_date,
 title
INTO partitioned_retiring_employees_by_title
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_employees_by_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

ALTER TABLE partitioned_retiring_employees_by_title
DROP COLUMN to_date;

--Creating table using CREATE method and importing created dataset
CREATE TABLE retiring_employees_by_title_final (
	emp_no INT NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	title VARCHAR NOT NULL,
	PRIMARY KEY (emp_no)
);

SELECT * FROM retiring_employees_by_title_final; 
