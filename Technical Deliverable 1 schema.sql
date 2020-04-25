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

--Title count for retiring employees
SELECT COUNT(ti.title), ce.emp_no
INTO titles_count
FROM current_emp as ce
INNER JOIN titles as ti
ON ce.emp_no = ti.emp_no
GROUP BY ce.emp_no
ORDER BY ce.emp_no;

SELECT * FROM titles_count_final;
DROP TABLE titles_count_final CASCADE


SELECT tic.emp_no,
ce.first_name,
ce.last_name,
ce.to_date,
tic.count
INTO retiring_employees_by_title_count 
FROM current_emp as ce
	INNER JOIN titles_count as tic
		ON (ce.emp_no = tic.emp_no)
ORDER BY ce.emp_no;

--Partition titles_count table 
SELECT emp_no,
 first_name,
 last_name,
 to_date,
 count
INTO titles_count_final
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 to_date,
 count, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_employees_by_title_count
 ) tmp WHERE rn = 1
ORDER BY emp_no;
