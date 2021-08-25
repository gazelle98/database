#1
SET @indexx := 0;
WITH RECURSIVE photo_no (dname, pno, indexx) AS (
(SELECT dynasty, count(pid), @indexx := @indexx + 1
FROM event 
	JOIN pictures ON (eid = event_id)
	JOIN countries ON (country_id = cid)
WHERE name = 'Iran'
)
UNION ALL
(SELECT dname, COUNT(pno)
FROM photo_no
WHERE indexx < 4
)
)
SELECT dname, count(pno)
FROM photo_no
GROUP BY dname;

#2
CREATE VIEW  tab AS SELECT title, full_path, full_name, name, dynasty
  FROM event, countries, pictures LEFT JOIN photographer ON taken_by = phid
  WHERE country_id = cid
  AND event_id = eid;

#3
DELIMITER $$
CREATE TRIGGER updating2
BEFORE DELETE ON countries
FOR EACH ROW 
BEGIN
	DELETE FROM pictures
	WHERE event_id = (SELECT eid FROM event WHERE old.cid = country_id);
END;
$$
DELIMITER ;

#4
SELECT e.dynasty, min(e.occured_at)
FROM event e, countries c
WHERE c.name = 'Iceland'
AND e.country_id = c.cid
GROUP BY e.dynasty,e. occured_at,e.title
ORDER BY e.title;

#5
UPDATE pictures
SET event_id = (SELECT eid FROM event WHERE dynasty = 'Ashkanian')
WHERE event_id = (SELECT eid FROM event WHERE dynasty = 'Ghajar');

UPDATE pictures
SET event_id = (SELECT eid FROM event WHERE dynasty = 'Ghajar')
WHERE event_id = (SELECT eid FROM event WHERE dynasty = 'Ashkanian');


#6
SELECT AVG(age)
FROM photographer
WHERE phid = ( SELECT DISTINCT p.phid
	FROM photographer p, countries c, event e, pictures pi
	WHERE p.phid = pi.taken_by
		AND e.eid = pi.event_id
		AND e.country_id = c.cid
		AND c.name = 'Brazil'
);

#7
SELECT DISTINCT e.dynasty
FROM event e, pictures pi, countries c, photographer p
WHERE p.born_in = 'Mexico'
AND e.eid = pi.event_id
AND pi.taken_by = p.phid
GROUP BY e.dynasty
HAVING COUNT(*)>=50;
