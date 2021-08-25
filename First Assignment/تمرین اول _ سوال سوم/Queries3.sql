#Queries

#01
SELECT max(ticket_price)
FROM Concert
WHERE location = 'Royal Concert Hall';

#02
SELECT DISTINCT c.location 
FROM Concert c
WHERE c.ticket_price >= 200;

#03
SELECT a.auid, a.full_name, a.age, a.gender
FROM Audience a
WHERE a.auid IN ( 	
	SELECT at.auid
    FROM Attended at
    WHERE at.cid = 'C28'
    );
    
#04
SELECT sid, title, aid, genre, duration
FROM Song
WHERE aid IN (
	SELECT aid
    FROM Artist
    WHERE name = 'Salar Aghili'
    ) and sid IN (
		SELECT sid
        FROM Playedin
        WHERE cid IN (
			SELECT cid
            FROM Concert
            WHERE location = 'Milad Tower'
            )
		);
        
#05
SELECT name
FROM Artist
WHERE country = 'Russia' AND age = (
	SELECT max(age) FROM Artist);
    
#06
SELECT avg(age)
FROM Audience
WHERE auid IN (
	SELECT auid
    FROM Attended
    WHERE cid IN( 
		SELECT cid
        FROM Playedin
        WHERE sid IN (
			SELECT aid
            FROM Song
            WHERE aid IN ( 
				SELECT aid
				FROM Artist
                WHERE name = 'Sirvan Khosravi'
                )
			)
		)
	);

#07
SELECT title
FROM Song
WHERE genre = 'pop' AND aid = (
	SELECT aid
    FROM Artist
    WHERE name = 'Elvis Presley'
    );

#08
SELECT title
FROM Song
WHERE genre = 'rock' AND aid = (
	SELECT aid
    FROM Artist
    WHERE country = 'Iran'
    );
    
#09
SELECT sum(ticket_price)
FROM Concert
WHERE location = 'Milad Tower';
            
#10
SELECT DISTINCT full_name
FROM Audience
WHERE auid IN (
	SELECT auid
    FROM Attended
    WHERE cid IN( 
		SELECT cid
        FROM Concert
        WHERE year = 2010
        )
	);

#11
SELECT count(*),gender
FROM Audience
WHERE auid IN(
	SELECT auid
    FROM Attended
    WHERE cid IN (
		SELECT cid
        FROM Playedin
        WHERE sid IN (
			SELECT sid
            FROM Song
            WHERE title = 'Hobab' AND aid IN( 
				SELECT aid
                FROM Artist
                WHERE name = 'Mohsen Yeganeh'
                )
			)
		)
	)
GROUP BY gender;
 