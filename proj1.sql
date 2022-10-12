-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era)
  FROM pitching -- replace this line
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT  namefirst, namelast, birthyear
  FROM people
  WHERE weight >300;
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE "% %"
  ORDER BY namefirst, namelast;
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT birthyear, avg(height), count(*)
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear;
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT birthyear, avg(height), count(*)
  FROM people
  GROUP BY birthyear
  HAVING avg(height) > 70
  ORDER BY birthyear;
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT namefirst, namelast, playerid, yearid
  FROM people NATURAL JOIN halloffame 
  WHERE halloffame.inducted = 'Y'
  ORDER BY yearid DESC, playerid
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  -- SELECT 1, 1, 1, 1, 1 -- replace this line
  SELECT namefirst, namelast, p.playerid, S.schoolid, yearid
  FROM people AS p, schools AS S, CollegePlaying AS C, halloffame AS H
  WHERE H.playerid = p.playerid AND p.playerid = C.playerid AND C.schoolid = S.schoolid AND S.schoolState = 'CA' AND H.inducted = 'Y'
  ORDER BY yearid DESC, S.schoolid, p.playerid;
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT p.playerid, namefirst, namelast, schoolid -- 太鸡巴难想了
  FROM ((people AS p INNER JOIN  halloffame AS H --先把Player和HallofFame内连接，得到进入名人堂的球员的表
          ON H.playerid = p.playerid AND H.inducted = 'Y') LEFT OUTER JOIN  CollegePlaying AS C  
          ON C.playerid = p.playerid) -- 得到的结果和CollegePlaying左侧外联结，保留左侧，于是匹配上的就是在学校打过球的名人，而没和右侧有匹配的，就是没在学校打过球的名人堂球员。  
  ORDER BY H.playerid DESC, schoolid
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, namefirst, namelast, yearid, ROUND(CAST((H-H2B-H3B-HR+2*H2B+3*H3B+4*HR) AS float)/CAST(AB AS float),4) AS slg
  FROM batting, people AS p
  WHERE batting.playerid = p.playerid AND AB > 50
  ORDER BY slg DESC, yearid, p.playerid
  LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT P.playerid, P.namefirst, P.namelast, 
  ROUND( CAST((l.H - l.H2B - l.H3B - l.HR + 2*l.H2B + 3 * l.H3B + 4*l.HR) AS float )/ CAST(l.AB as float),4) as lslg
  FROM people P INNER JOIN 
  (
  SELECT b.playerid, SUM(B.H) as H, SUM(B.H2B) as H2B, SUM(B.H3B) as H3B,SUM(B.HR) as HR,
  SUM(B.AB) as AB
  FROM Batting B 
  GROUP BY B.playerid) as l
  ON P.playerid = l.playerid
  WHERE l.AB > 50
  ORDER BY lslg DESC, P.playerid
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  -- SELECT 1, 1, 1 -- replace this line
  SELECT P.namefirst, P.namelast,ROUND( CAST((l.H - l.H2B - l.H3B - l.HR + 2*l.H2B + 3 * l.H3B + 4*l.HR) AS float )/ CAST(l.AB as float),4) as lslg
  FROM people P INNER JOIN 
  (
  SELECT b.playerid, SUM(B.H) as H, SUM(B.H2B) as H2B, SUM(B.H3B) as H3B,SUM(B.HR) as HR,
  SUM(B.AB) as AB
  FROM Batting B 
  GROUP BY B.playerid) AS l
  ON P.playerid=l.playerid
  WHERE lslg > (
  SELECT ROUND( CAST((l.H - l.H2B - l.H3B - l.HR + 2*l.H2B + 3 * l.H3B + 4*l.HR) AS float )/ CAST(l.AB as float),4) as lslg
  FROM people P INNER JOIN 
  (
  SELECT b.playerid, SUM(B.H) as H, SUM(B.H2B) as H2B, SUM(B.H3B) as H3B,SUM(B.HR) as HR,
  SUM(B.AB) as AB
  FROM Batting B 
  WHERE B.playerid LIKE "mayswi01"
    ) as l
  ON P.playerid=l.playerid
  ) AND l.AB > 50
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  -- SELECT 1, 1, 1, 1 -- replace this line
  SELECT yearid, min(salary), max(salary), avg(salary)
  FROM salaries
  GROUP BY yearid
  ORDER BY yearid
;

-- Question 4ii
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(
  binid int
);
INSERT INTO binids(binid)
VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT binid,(min+binid*bin) AS low,(min+(binid+1)*bin) AS high,COUNT(*)
  FROM (
    SELECT CAST((MAX(salary) - MIN(salary))/10 AS INT) AS bin,MIN(salary) AS min
    FROM salaries
    WHERE yearid = 2016
    ),binids,salaries AS s
  WHERE s.salary BETWEEN low AND high AND s.yearid = 2016
  GROUP BY binid
;
-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
 -- SELECT 1, 1, 1, 1 -- replace this line
 	SELECT q2.yearid,(q2.min - q1.min) AS mindiff,(q2.max - q1.max) AS maxdiff,(q2.avg - q1.avg) AS avgdiff
  FROM q4i q1,q4i q2
  WHERE q2.yearid = q1.yearid + 1
  ORDER BY q2.yearid
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  -- SELECT 1, 1, 1, 1, 1 -- replace this line
  SELECT P.playerid,namefirst,namelast,salary,yearid
  FROM salaries S INNER JOIN people P
  ON S.playerid = P.playerid
  WHERE (salary >= (
      SELECT MAX(salary)
      FROM salaries
      WHERE yearid = 2000
    ) AND yearid = 2000) OR (salary >= (
      SELECT MAX(salary)
      FROM salaries
      WHERE yearid = 2001
    ) AND yearid = 2001)
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  -- SELECT 1, 1 -- replace this line
  SELECT A.teamID,MAX(S.salary) - MIN(S.salary) AS diffAvg
  FROM allstarfull A INNER JOIN salaries S
  ON A.playerid = S.playerid AND A.yearid = S.yearid
  WHERE A.yearid = 2016
  GROUP BY A.teamID
;

