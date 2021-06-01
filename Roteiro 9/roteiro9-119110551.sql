--Questão 01a:

CREATE VIEW vw_dptmgr
AS SELECT d.dnumber, e.fname, e.lname
FROM department AS d, employee AS e
WHERE d.mgrssn = e.ssn;

--Questão 01b:

CREATE VIEW vw_empl_houston
AS SELECT ssn, fname
FROM employee
WHERE address LIKE '%Houston%';

--Questão 01c:

CREATE VIEW vw_deptstats
AS SELECT d.dnumber, d.dname, COUNT(*)
FROM department as d, employee AS e
WHERE d.dnumber = e.dno
GROUP BY d.dnumber;

--Questão 01d:

CREATE VIEW vw_projstats
AS SELECT pno, COUNT(*)
FROM works_on
GROUP BY pno;

--Questão 02:

SELECT dnumber FROM vw_dptmgr;
SELECT ssn FROM vw_empl_houston;
SELECT * FROM vw_deptstats;
SELECT * FROM vw_dptmgr;

--Questão 03:

DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;

--Questão 04:

CREATE OR REPLACE FUNCTION check_age(eSsn char(9))
RETURNS varchar AS
$$

DECLARE
age integer;

BEGIN

	SELECT date_part('year'::text, age((bdate)::timestamp WITH time zone)) INTO age
	FROM employee AS e
	WHERE e.ssn = eSsn;
    
	IF (age >= 50) THEN RETURN 'SENIOR';
	ELSIF (age < 50 AND age >= 0) THEN RETURN 'YOUNG';
	ELSIF (age IS NULL) THEN RETURN 'UNKNOWN';
	ELSE RETURN 'INVALID';
	END IF;
   	 
END;
$$  LANGUAGE plpgsql;

--Questão 05:

CREATE OR REPLACE FUNCTION check_mgr() RETURNS TRIGGER AS $check_mgr$

DECLARE
eDno integer;
subordinates integer;

BEGIN

	SELECT dno
	FROM employee
	WHERE ssn = NEW.mgrssn
	INTO eDno;
	
	SELECT count(*)
	FROM employee
	WHERE superssn = NEW.mgrssn
	INTO subordinates;
    
	IF (NEW.dnumber <> eDno OR NEW.mgrssn NOT IN (SELECT ssn FROM employee) OR NEW.mgrssn IS NULL ) THEN
        	RAISE EXCEPTION 'manager must be a department''s employee';
        END IF;
	IF (subordinates = 0 OR subordinates IS NULL) THEN
        	RAISE EXCEPTION 'manager must be a SENIOR employee';
	END IF;
	IF (check_age(NEW.mgrssn) <> 'SENIOR') THEN
		RAISE EXCEPTION 'manager must have supervisees';
	END IF;
	RETURN NEW;
   	 
END;
$check_mgr$  LANGUAGE plpgsql;

CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department
	FOR EACH ROW EXECUTE PROCEDURE check_mgr();
