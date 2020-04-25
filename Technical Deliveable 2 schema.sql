-- Creating table with needed birthdates of current employees
SELECT e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.to_date
INTO eligible_birth_dates
FROM employees as e
	INNER JOIN dept_emp as de
	ON (de.emp_no = e.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01');
	
SELECT * FROM mentorship
DROP TABLE mentorship CASCADE 

--Challenge Table 2 Mentorship Eligibility JAN 1,1965-DEC 31, 1965, USE 2 INNER JOINS
SELECT eg.emp_no,
eg.first_name,
eg.last_name,
s.from_date,
eg.to_date,
ti.title
INTO mentorship
FROM eligible_birth_dates as eg
	INNER JOIN salaries as s
		ON (eg.emp_no = s.emp_no)
	INNER JOIN titles as ti
		ON (eg.emp_no = ti.emp_no)
ORDER BY eg.emp_no;

 -- Partition the data to remove duplicates
SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title
INTO partitioned_mentorship_final
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM partitioned_mentorship_final;

