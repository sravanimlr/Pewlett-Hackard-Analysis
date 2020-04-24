--CHALLENGE TABLE 2
--Filtering employees by birthdate   
SELECT emp_no, first_name, last_name
INTO eligible_by_birth_date
FROM employees
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')  

--Challenge Table 2 Mentorship Eligibility JAN 1,1965-DEC 31, 1965, USE 2 INNER JOINS
SELECT eg.emp_no,
eg.first_name,
eg.last_name,
s.from_date,
s.to_date,
ti.title
INTO mentorship_eligible
FROM eligible_by_birth_date as eg
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
INTO partitioned_mentorship_eligible
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship_eligible
 ) tmp WHERE rn = 1
ORDER BY emp_no;

--Creating table using CREATE method 
CREATE TABLE mentorship_eligible_final (
	emp_no INT NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	title VARCHAR NOT NULL,
	PRIMARY KEY(emp_no)	
); 

SELECT * FROM mentorship_eligible_final;