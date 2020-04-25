-- CHALLENGE TABLE 1
--Challenge Table 1(using INTO METHOD) Number of Retiring Employees by Title 
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
de.from_date,
s.salary,
ce.to_date,
ti.title
INTO retiring_employees 
FROM current_emp as ce
	INNER JOIN salaries as s
		ON (ce.emp_no = s.emp_no)
	INNER JOIN dept_manager as de
		ON (de.from_date = s.from_date)
	INNER JOIN titles as ti
		ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 from_date,
 salary,
 to_date,
 title
INTO partitioned_retiring_emp_by_title
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 salary,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_employees
 ) tmp WHERE rn = 1
ORDER BY emp_no;

ALTER TABLE partitioned_retiring_emp_by_title
DROP COLUMN to_date;
