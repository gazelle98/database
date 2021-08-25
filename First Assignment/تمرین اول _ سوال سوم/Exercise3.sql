#Creating Databse
CREATE DATABASE Exe3;

#Creating Tables
CREATE TABLE Artist(
aid VARCHAR(5),
name VARCHAR(20),
country VARCHAR(15),
age INT,
gender VARCHAR(10),
PRIMARY KEY(aid)
);

CREATE TABLE Song(
sid VARCHAR(5),
title VARCHAR(20),
aid VARCHAR(5),
genre VARCHAR(15),
duration TIME,
PRIMARY KEY(sid),
FOREIGN KEY(aid) REFERENCES Artist(aid)
);

CREATE TABLE Concert(
cid VARCHAR(5),
location VARCHAR(200),
ticket_price INT,
year YEAR,
PRIMARY KEY(cid)
);

CREATE TABLE Playedin(
sid VARCHAR(5),
cid VARCHAR(5),
FOREIGN KEY(sid) REFERENCES Song(sid),
FOREIGN KEY(cid) REFERENCES Concert(cid)
);

CREATE TABLE Audience(
auid VARCHAR(5),
full_name VARCHAR(20),
age INT,
gender VARCHAR(10),
PRIMARY KEY(auid)
);

CREATE TABLE Attended(
auid VARCHAR(5),
cid VARCHAR(5),
FOREIGN KEY(auid) REFERENCES Audience(auid),
FOREIGN KEY(cid) REFERENCES Concert(cid)
);

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
 