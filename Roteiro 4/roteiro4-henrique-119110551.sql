-- Q1:
SELECT * FROM department;

-- Q2:
SELECT * FROM dependent;

-- Q3:
SELECT * FROM dept_locations;

-- Q4:
SELECT * FROM employee;

-- Q5:
SELECT * FROM project;

-- Q6:
SELECT * FROM works_on;

-- Q7:
SELECT fname, lname FROM employee WHERE sex = 'M';

-- Q8:
SELECT fname FROM employee WHERE sex = 'M' AND superssn IS NULL;

-- Q9:
SELECT e.fname, s.fname FROM employee AS e, employee AS s WHERE e.superssn IS NOT NULL AND e.superssn = s.ssn;

-- Q10:
SELECT e.fname FROM employee AS e, employee AS s WHERE s.fname = 'Franklin' AND s.ssn = e.superssn;

-- Q11:
SELECT d.dname, l.dlocation FROM department AS d, dept_locations AS l WHERE d.dnumber = l.dnumber;

-- Q12:
SELECT d.dname FROM department AS d, dept_locations AS l WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';

-- Q13:
SELECT e.fname, e.lname, d.dependent_name FROM employee AS e, dependent AS d WHERE e.ssn = d.essn;

-- Q14:
SELECT (e.fname || ' ' || e.minit || ' ' || e.lname) AS full_name, e.salary FROM employee AS e WHERE e.salary > 50000;

-- Q15:
SELECT p.pname, d.dname FROM project AS p, department AS d WHERE p.dnum = d.dnumber;

-- Q16:
SELECT p.pname, e.fname FROM project AS p, department AS d, employee AS e WHERE p.pnumber > 30 AND p.dnum = d.dnumber AND d.mgrssn = e.ssn;

-- Q17:
SELECT p.pname, e.fname FROM project AS p, works_on AS w, employee AS e WHERE p.pnumber = w.pno AND w.essn = e.ssn;

-- Q18:
SELECT e.fname, d.dependent_name, d.relationship FROM employee AS e, dependent AS d, works_on AS w WHERE w.pno = 91 AND w.essn = e.ssn AND e.ssn = d.essn;
