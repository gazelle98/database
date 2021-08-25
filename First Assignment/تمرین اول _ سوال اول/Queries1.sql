
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
