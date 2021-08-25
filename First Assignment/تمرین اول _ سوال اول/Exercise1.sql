#Creating Database
CREATE DATABASE Exercise1;

#Creating Tables
CREATE TABLE Team(
tid INT,
name VARCHAR(20),
country VARCHAR(15),
city VARCHAR(15),
score INT,
being_in_AFC_champions_league_status BOOL,
PRIMARY KEY(tid)
);

CREATE TABLE Player(
pid INT,
name VARCHAR(20),
age INT,
nationality VARCHAR(15),
role VARCHAR(15),
is_captain BOOL,
being_in_national_team_status BOOL,
PRIMARY KEY(pid)
);

CREATE TABLE League(
year YEAR,
PRIMARY KEY(year)
);

CREATE TABLE Injuries(
date DATE,
pid INT,
FOREIGN KEY(pid) REFERENCES Player(pid)
);

CREATE TABLE Coach(
cid INT,
name VARCHAR(20),
age INT,
tid INT,
nationality VARCHAR(15),
PRIMARY KEY(cid),
FOREIGN KEY(tid) REFERENCES Team(tid)
);

CREATE TABLE Game(
gid INT,
date DATE,
ggoal INT,
hgoal INT,
PRIMARY KEY(gid)
);

CREATE TABLE Playedin(
pid INT,
tid INT,
FOREIGN KEY(pid) REFERENCES Player(pid),
FOREIGN KEY(tid) REFERENCES Team(tid)
);

CREATE TABLE Game_rel(
guest_tid INT,
host_tid INT,
gid INT,
FOREIGN KEY(guest_tid) REFERENCES Team(tid),
FOREIGN KEY(host_tid) REFERENCES Team(tid),
FOREIGN KEY(gid) REFERENCES Game(gid)
);

#Inserting Some Datas
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(1,'Perspolis', 'Iran', 'Tehran', 25, 1);
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(2,'Esteghlal', 'Iran', 'Tehran', 23, 1);
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(3,'Saipa', 'Iran', 'Karaj', 17, 0);
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(4,'Sepahan', 'Iran', 'Isfahan', 18, 1);
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(5,'Zobahan', 'Iran', 'Isfahan', 20, 1);
INSERT INTO Team(tid, name, country, city, score, being_in_AFC_champions_league_status) VALUES(6,'Sepidrood', 'Iran', 'Gilan', 14, 0);

INSERT INTO Player(pid, name, age, nationality, role, is_captain, being_in_national_team_status) VALUES(1, 'Mehdi Mahdavikia', 35, 'Iran', 'Defender', 1, 1);
INSERT INTO Player(pid, name, age, nationality, role, is_captain, being_in_national_team_status) VALUES(2, 'Ali Karimi', 31, 'Iran', 'Midfielder', 0, 1);
INSERT INTO Player(pid, name, age, nationality, role, is_captain, being_in_national_team_status) VALUES(3, 'Alireza Haghighi', 25, 'Iran', 'Goalkeeper', 0, 0);
INSERT INTO Player(pid, name, age, nationality, role, is_captain, being_in_national_team_status) VALUES(4, 'Mehdi Bagheri', 32, 'Iran', 'Midfielder', 1, 1);
INSERT INTO Player(pid, name, age, nationality, role, is_captain, being_in_national_team_status) VALUES(5, 'Karim Ansari', 23, 'Iran', 'Forward', 0, 1);

INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(1, 'Arman Molaie', 34, 3, 'Brazil');
INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(2, 'Ali Amini', 25, 2, 'Argentina');
INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(3, 'Ehsan Tavakoli', 31, 4, 'Iran');
INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(4, 'Sina Rasooli', 26, 1, 'Iran');
INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(5, 'Arian Sheikhi', 28, 5, 'Iran');
INSERT INTO Coach(cid, name, age, tid, nationality) VALUE(6, 'Hamed Kalimi', 37, 6, 'Iran');

INSERT INTO Playedin(pid,tid) VALUES(2,6);
INSERT INTO Playedin(pid,tid) VALUES(1,6);
INSERT INTO Playedin(pid,tid) VALUES(4,3);
INSERT INTO Playedin(pid,tid) VALUES(3,5);
INSERT INTO Playedin(pid,tid) VALUES(5,4);

INSERT INTO Game(gid, date, ggoal, hgoal) VALUES(1, '2009-12-04', 2,4);
INSERT INTO Game(gid, date, ggoal, hgoal) VALUES(2, '2014-03-04',3, 0);
INSERT INTO Game(gid, date, ggoal, hgoal) VALUES(3, '2012-10-23',5, 4);
INSERT INTO Game(gid, date, ggoal, hgoal) VALUES(4, '2014-03-04',1, 0);
INSERT INTO Game(gid, date, ggoal, hgoal) VALUES(5, '2016-07-18',0, 0);

INSERT INTO Game_rel(guest_tid, host_tid, gid) VALUES(3,1,1);
INSERT INTO Game_rel(guest_tid, host_tid, gid) VALUES(1,3,2);
INSERT INTO Game_rel(guest_tid, host_tid, gid) VALUES(2,5,3);
INSERT INTO Game_rel(guest_tid, host_tid, gid) VALUES(4,3,4);
INSERT INTO Game_rel(guest_tid, host_tid, gid) VALUES(3,2,5);

#Queries

#01
SELECT t.score, t.name
FROM Team t
WHERE t.name = 'Perspolis' OR t.name = 'Esteghlal';

#02
SELECT g.gid
FROM Game g, Game_rel gr
WHERE (g.gid = gr.gid) AND (
(gr.host_tid = (SELECT tid FROM Team WHERE name = 'Saipa')
 	 AND g.hgoal < g.ggoal
	 AND g.ggoal IN (SELECT max(mgoal) FROM ((SELECT max(g.ggoal) AS mgoal FROM Game g WHERE g.gid IN (SELECT gr.gid FROM Game_rel gr WHERE gr.host_tid = (SELECT tid FROM Team WHERE name = 'Saipa')))
									UNION(SELECT max(g.hgoal) AS mgoal FROM Game g WHERE g.gid IN (SELECT gr.gid FROM Game_rel gr WHERE gr.guest_tid = (SELECT tid FROM Team WHERE name = 'Saipa')))) AS E))
OR 
(gr.guest_tid = (SELECT tid FROM Team WHERE name = 'Saipa')
	AND g.hgoal > g.ggoal
    AND g.hgoal IN (SELECT max(mgoal) FROM ((SELECT max(g.ggoal) AS mgoal FROM Game g WHERE g.gid IN (SELECT gr.gid FROM Game_rel gr WHERE gr.host_tid = (SELECT tid FROM Team WHERE name = 'Saipa')))
									UNION(SELECT max(g.hgoal) AS mgoal FROM Game g WHERE g.gid IN (SELECT gr.gid FROM Game_rel gr WHERE gr.guest_tid = (SELECT tid FROM Team WHERE name = 'Saipa')))) AS E))
);

#03
SELECT t.name, t.score
FROM Team t
WHERE t.score = (
	SELECT min(score)
    FROM Team
    );

#04
SELECT t.name, t.score
FROM Team t
WHERE t.score = (
	SELECT max(score)
    FROM Team
    );

#05
SELECT c.name
FROM Coach c
WHERE c.tid IN(
	SELECT t.tid
    FROM Team t
    WHERE t.score =(
		SELECT max(tt.score)
        FROM Team tt
        )
	);
    
#06
SELECT DISTINCT t.name, tt.name
FROM Team t, Team tt, Game g, Game_rel gr
WHERE g.gid = gr.gid AND t.tid = gr.host_tid AND tt.tid = gr.guest_tid AND (g.ggoal+g.hgoal = (SELECT max(g.ggoal+g.hgoal) FROM Game g));

#07  
SELECT team FROM
((SELECT Team.name AS team, sum(Game.ggoal) AS goal
FROM Game, Team, Game_rel
WHERE Game.gid = Game_rel.gid AND Game_rel.host_tid = Team.tid GROUP BY Game_rel.host_tid)
UNION
(SELECT Team.name AS team, sum(Game.hgoal) AS goal
FROM Game, Team, Game_rel
WHERE Game_rel.gid = Game.gid AND Team.tid = Game_rel.guest_tid GROUP BY Game_rel.guest_tid)) AS E
GROUP BY team ORDER BY sum(goal)DESC LIMIT 1;

#08
SELECT team FROM
((SELECT Team.name AS team, sum(Game.hgoal) AS goal
FROM Game, Team, Game_rel
WHERE Game.gid = Game_rel.gid AND Game_rel.host_tid = Team.tid GROUP BY Game_rel.host_tid)
UNION
(SELECT Team.name AS team, sum(Game.ggoal) AS goal
FROM Game, Team, Game_rel
WHERE Game_rel.gid = Game.gid AND Team.tid = Game_rel.guest_tid GROUP BY Game_rel.guest_tid)) AS E
GROUP BY team ORDER BY sum(goal)DESC LIMIT 1;
        
#09
SELECT p.name
FROM Player p
WHERE p.is_captain = 1 AND pid IN(
	SELECT pl.pid
    FROM Playedin pl
    WHERE pl.tid IN(
		SELECT t.tid
        FROM Team t
        WHERE t.name = 'Zobahan'
        )
	);
        
#10
SELECT p.name
FROM Player p
WHERE p.pid IN(
	SELECT pl.pid
    FROM Playedin pl
    WHERE pl.tid IN(
		SELECT t.tid
        FROM Team t
        WHERE t.name = 'Siah Jamegan'
        )
	) AND (
    SELECT p.pid IN(
		SELECT i.pid
        From Injuries i
        )
	);
        
#11
SELECT p.name
FROM Player p
WHERE p.role = 'Forward' AND pid IN(
	SELECT pl.pid
    FROM Playedin pl
    WHERE pl.tid IN(
		SELECT t.tid
        FROM Team t
        WHERE t.being_in_AFC_champions_league_status = 1
        )
	);
    

#12
SELECT p.pid, p.name, p.age, p.nationality, p.role, p.being_in_national_team_status
FROM Player p
WHERE p.being_in_national_team_status = 1 AND age =(
	SELECT min(pp.age)
    FROM Player pp
    );
    
#13
SELECT p.name
FROM Player p
WHERE p.being_in_national_team_status = 1 AND p.pid IN(
	SELECT pl.pid
    FROM Playedin pl
    WHERE pl.tid IN(
		SELECT t.tid
        FROM Team t
        WHERE t.name = 'Sepidrood'
        )
	);
	
#14
SELECT p.name
FROM Player p
WHERE p.is_captain = 1;
	
#15
SELECT t.tid, t.name, t.country, t.city, t.score, t.being_in_AFC_champions_league_status
FROM Team t
WHERE t.city = 'Tehran' AND t.being_in_AFC_champions_league_status = 1;