--Q1:
SELECT COUNT(*) FROM employee WHERE sex = 'F';

--Q2:
SELECT AVG(salary) FROM employee WHERE sex = 'M' AND address LIKE '%TX';

--Q3:
SELECT s.ssn AS ssn_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS s RIGHT OUTER JOIN employee AS e ON e.superssn = s.ssn) GROUP BY s.ssn ORDER BY COUNT(*) ASC;

--Q4:
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS s INNER JOIN employee AS e ON e.superssn = s.ssn) GROUP BY s.fname ORDER BY COUNT(*) ASC;

--Q5:
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS s RIGHT OUTER JOIN employee AS e ON e.superssn = s.ssn) GROUP BY s.fname ORDER BY COUNT(*) ASC;

--Q6:
SELECT MIN(qtd_fw) AS qtd FROM (SELECT COUNT(*) AS qtd_fw FROM project AS pj, works_on AS w WHERE pj.pnumber = w.pno GROUP BY pj.pname) AS qtd_func_works_on;

--Q7:
SELECT pno AS num_projeto, qtd AS qtd_func FROM ((SELECT pno, COUNT(*) AS qtd FROM works_on GROUP BY pno) AS num_proj JOIN (SELECT min(count) AS qtd_proj FROM (SELECT COUNT(*) FROM works_on GROUP BY pno) AS qtd2 ) AS min_proj ON num_proj.qtd = min_proj.qtd_proj) ORDER BY num_projeto ASC;

--Q8:
SELECT p.pnumber AS num_proj, AVG(e.salary) AS media_sal FROM project AS p, employee AS e, works_on AS w WHERE p.pnumber = w.pno AND w.essn = e.ssn GROUP BY p.pnumber;

--Q9:
SELECT p.pnumber AS proj_num, p.pname AS proj_nome, AVG(e.salary) AS media_sal FROM project AS p, employee AS e, works_on AS w WHERE p.pnumber = w.pno AND w.essn = e.ssn GROUP BY p.pnumber, p.pname;

--Q10:
SELECT e.fname, e.salary FROM employee AS e WHERE e.salary > ALL (SELECT f.salary FROM employee AS f, works_on AS w WHERE w.pno = 92 AND w.essn = f.ssn);

--Q11:
SELECT e.ssn AS ssn, COUNT(w.pno) AS qtd_proj FROM employee AS e LEFT OUTER JOIN works_on AS w ON e.ssn = w.essn GROUP BY e.ssn ORDER BY qtd_proj ASC;

--Q12:
SELECT w.pno AS num_proj, COUNT(e.ssn) as qtd_func FROM works_on AS w RIGHT OUTER JOIN employee as e ON e.ssn = w.essn GROUP BY w.pno HAVING COUNT(e.ssn) < 5 ORDER BY COUNT(e.ssn) ASC;

--Q13:
SELECT e.fname FROM employee AS e WHERE e.ssn IN (SELECT w.essn FROM works_on AS w WHERE w.pno IN (SELECT p.pnumber FROM project AS p WHERE p.plocation = 'Sugarland')) AND e.ssn IN (SELECT essn FROM dependent) GROUP BY fname;

--Q14:
SELECT dname FROM department AS d WHERE EXISTS(SELECT dnumber FROM department) AND NOT EXISTS(SELECT dnum FROM project AS p WHERE d.dnumber = p.dnum);

--Q15:
SELECT e.fname, e.lname FROM employee AS e WHERE NOT EXISTS ((SELECT w.pno FROM works_on AS w WHERE w.essn = '123456789') EXCEPT (SELECT wo.pno FROM works_on AS wo WHERE e.ssn = wo.essn AND NOT(wo.essn = '123456789')));

--Q16:
SELECT e.fname, e.salary FROM employee AS e WHERE e.salary > ALL (SELECT e.salary FROM employee AS e, works_on AS w, ((SELECT p.pnumber AS proj_num, AVG(e.salary) AS media_sal FROM project AS p, employee AS e, works_on AS w WHERE p.pnumber = w.pno AND w.essn = e.ssn GROUP BY p.pnumber, p.pname) AS avg_proj JOIN (SELECT MAX(media_proj) AS qtd_max_proj FROM (SELECT AVG(e.salary) AS media_proj FROM project AS p, employee AS e, works_on AS w WHERE p.pnumber = w.pno AND w.essn = e.ssn GROUP BY p.pnumber, p.pname) AS avg2) AS max_proj ON avg_proj.media_sal = max_proj.qtd_max_proj) AS max_avg_proj WHERE w.pno = max_avg_proj.proj_num AND w.essn = e.ssn);
