--Intermediate SQL
--Example 1
SELECT
	l.name AS league,
	COUNT(m.country_id) AS matches
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
GROUP BY l.name;

--Gives you number of matches between each league listed

--Example 2
SELECT
	date,
	id,
	home_goal,
	away_goal
FROM match
WHERE season = '2013/2014'
	AND home_team_goal > away_team_goal;

--Compare hometeam wins, away team wins, and ties in the 2013, 2014 season
--Wins, loses and ties can be selected 


--Case statements are SQLs version of if this then that 
--Case statements have three parts: WHEN clause, a THEN clause, and an ELSE clause 

CASE WHEN x = 1 THEN 'a'
	WHEN x = 2 THEN 'b'
	ELSE 'c' END AS new_column

--When you complete the case statement be sure to include an END and give it an alias

--Example 3
SELECT 
	id,
	home_goal,
	away_goal,
	CASE WHEN home_goal > away_goal THEN 'Home Team Win'
		WHEN home_goal < away_goal THEN 'Away Tea Win'
		ELSE 'Tie' END AS outcome
FROM match
WHERE season = '2013/2014';

/*
processing order of SQL operations is:
1. from
2. where
3. group by
4. having
5. select
6. order by
7. limit
*/


SELECT
	-- Select the team long name and team API id
	team_long_name,
	team_api_id
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');


-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT
        CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
                WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
                ELSE 'Other' END AS home_team,
                COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;


/*
CASE statements comparing column values
*/
 
SELECT 
	-- Select the date of the match
	date,
	-- Identify home wins, losses, or ties
	CASE WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN 'Home loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain;


SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;


SELECT 
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634; 


/*
CASE statements comparing two column values part 2
*/

-- Select matches where Barcelona was the away team
SELECT  
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.home_goal < m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal > m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Join teams_spain to matches_spain
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;


--Example 4
--Using multiple logical conditions to your WHEN clause 
SELECT date, home_id, awayteam_id,
	CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
		THEN 'Chelsea and home win!'
	WHEN awayteam_id = 8455 AND home_goal < away_goal
		THEN 'Chelsea away win!'
	ELSE 'Loss or tie :(' END AS outcome
FROM match
WHERE hometeam_id = 8455 OR awayteam_id = 8455;

--Example 5
SELECT date,
CASE WHEN date > '2015-01-01' THEN 'More Recently'
	WHEN date < '2012-01-01' THEN 'Older'
	END AS date_category
FROM match;
SELECT WHEN data > '2015-01-01' THEN 'More Recently'
	WHEN date < '2012-01-01' THEN 'Older'
	ELSE NULL END AS date_category
FROM match;
	

--Reviewing the results of games and they don't care if they lose or win
SELECT data, season,
	CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
		THEN 'Chelsea home win!'
	WHEN awayteam_id = 8455 AND home_goal < away_goal
		THEN 'Chelsea away win!'
	END AS outcome
FROM match
WHERE hometeam_id = 8455 OR awayteam_id = 8455;


/*
Filter a query by a case statement, except its alias, in WHERE, you then specify
what you want to include and exclude. 
The following clears all rows where the case statement is not NULL
*/ 

SELECT data, season, 
	CASE WHEN hometeam_id = 8455 AND home_goal > away_goal 
		THEN 'Chelsea home win!'
	WHEN awayteam_id = 8455 AND home_goal < away_goal
		THEN 'Chelsea away win!' END AS outcome
FROM match 
WHERE CASE WHEN hometeam_id = 8455 AND home_goal < away_goal
	THEN 'Chelsea away win!' END IS NOT NULL;


--In case of rivalry
SELECT 
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);


--
SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);
	  
	  
--Filtering your CASE statement 

-- Select team_long_name and team_api_id from team
SELECT
	team_long_name,
	team_api_id
FROM teams_italy
-- Filter for team name
WHERE team_long_name = 'Bologna';

--

-- Select the season and date columns
SELECT 
	season,
	date,
    -- Identify when Bologna won a match
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END AS outcome
FROM matches_italy;

--

-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
    date,
	home_goal,
	away_goal
FROM matches_italy
WHERE 
-- Exclude games not won by Bologna
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END IS NOT NULL;
		
/*
CASE WHEN with aggregate functions 
CASE statements are great for: categorizing data, filtering data, aggregate data
*/

--CASE WHEN with COUNT
SELECT 
	season,
	COUNT(CASE WHEN hometeam_id = 8650)
		AND home_goal > away_goal
		THEN id END) AS home_wins
FROM match
GROUP BY season;

--CASE WHEN with COUNT
SELECT
	season,
	COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal 
		THEN id END) AS home_wins,
	COUNT(CASE WHEN awayteam_id = 8650 AND away_goal > home_goal
		THEN id END) AS away_wins
FROM match
GROUP BY season;

--CASE WHEN with SUM
SELECT 
	season,
	SUM(CASE WHEN hometeam_id = 8650
		THEN home_goal END) AS home_goals,
	SUM(CASE WHEN awayteam_id = 8650
		THEN away_goal END) AS away_goals
FROM match 
GROUP BY season;

--CASE is AVG
SELECT 
	season,
	AVG(CASE WHEN hometeam_id = 8650)
		THEN home_goal END) AS home_goals,
	AVG(CASE WHEN awyteam_id = 8650
		THEN away_goal END) AS away_goals
FROM match
GROUP BY season;

--Rounding the average
--Example 1
ROUND(3.141592653589, 2)

--Example 2
SELECT 
	season,
	ROUND(AVG(CASE WHEN hometeam_id = 8650
		THEN home_goal END),2) AS home_goals,
	ROUND(AVG(CASE WHEN awayteam_id = 8650
		THEN away_goal END), 2) AS away_goals
FROM match
GROUP BY season;


--Percentages with CASE and AVG
SELECT
	season,
	AvG(CASE WHEN hometeam_id = 8455 AND home_goal THEN 1
			WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
			END) AS pct_homewins
	AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
			WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
			END) AS pct_awaywins
FROM match 
GROUP BY season;

--Count using CASE WHEN
SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	COUNT(CASE WHEN m.season = '2012/2013' 
        	THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;


SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(CASE WHEN m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN m.id END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN m.id END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;


/*
COUNT and CASE WHEN with multiple conditions
*/

SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(CASE WHEN m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE NULL END) AS matches_2012_2013,
 	SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

/*
Calculating percent with CASE and AVG
AVG(CASE WHEN condition_is_met THEN 1
         WHEN condition_is_not_met THEN 0 END)
*/

--Example 1
SELECT 
    c.name AS country,
    -- Count the home wins, away wins, and ties in each country
	COUNT(CASE WHEN m.home_goal > m.away_goal THEN m.id 
        END) AS home_wins,
	COUNT(CASE WHEN m.home_goal < m.away_goal THEN m.id 
        END) AS away_wins,
	COUNT(CASE WHEN m.home_goal = m.away_goal THEN m.id 
        END) AS ties
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

--Example 2
SELECT 
	c.name AS country,
    -- Calculate the percentage of tied games in each season
	AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2013_2014,
	AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

--Example 3
SELECT 
	c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
	ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;


/*
In order to retrieve information you want, you have to perform some intermediary transformations to your data before selecting, filtering, calculating information
Subqueries are a common way of performing this transformation 

SELECT column
FROM (SELECT column 
	FROM table) AS subquery;

What can you do with a subquery
 Can be in any part of a query 
* SELECT, FROM, WHERE, GROUP BY 
 Can return a variety of information
 * Scalar quantities (3.14159, -2, 0.001)
 * A list (id = (12, 25, 392, 401, 939))
 * A table 
 
Why subqueries 
 Comparing groups to summarized values 
 * How did Liverpool compare to the English Premier League's average performance for that year?
 
 Reshaping data 
 * What is the highest monthly average of goals scored in the Bundesliga? 

 Combining data that cannot be joined 
 * How do you get both the home and away team names into a table of match results? 
 
 Definition of a simple subquery 
 * Can be evaluated idependently from the outer query 
 
 SELECT home_goal
 FROM match 
 WHERE home_goal > (
	SELECT AVG(home_goal)
	FROM match);
SELECT AVG(home_goal) FROM match; 

In the above example the subquery WHERE is processed first, generating the overall average of home goals scored SQL then moves onto the main query, treating the subquery 
like the single, aggregate value it just generated

higher than the overall average 
SELECT AVG(home_goal) FROM match;

include the number in the main query 
SELEcT  date, hometeam_id, awayteam_id, home_goal, away_goal
FROM match
WHERE season = '2012/2013'
	AND home_goal > 1.56091291478423; 
	
OR you can put the query directly into the where clause

SELECT date, hometeam_id, awayteam_id, home_goal, away_goal 
FROM match 
WHERE season = '2012/2013'
	AND home_goal > (SELECT AVG(home_goal)	
					FROM match);
					
Subqueries are also usful when using a filtering lsit with IN
*Which team are part of Poland league? 

SELECT 
	team_long_name,
	team_short_name AS abbr
FROM team 
WHERE 
	team_api_id IN	
	(SELECT hometeam_id
	FROM match
	WHERE country_id = 15722);
*/

--Filtering using sclalar subqueries
-- Select the average of home + away goals, multiplied by 3
--Example 1
SELECT 
	3 * AVG(home_goal + away_goal)
FROM matches_2013_2014;

--Example 2
SELECT 
	-- Select the date, home goals, and away goals scored
    date,
	home_goal,
	away_goal
FROM matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_goal + away_goal) > 
       (SELECT 3 * AVG(home_goal + away_goal)
        FROM matches_2013_2014); 

--Filtering using a subquery with a list 
--Example 1
SELECT 
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id NOT IN
    (SELECT DISTINCT hometeam_id  FROM match);

--Example 2
SELECT
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team
-- Filter for teams with 8 or more home goals
WHERE team_api_id IN
	  (SELECT hometeam_id 
       FROM match
       WHERE home_goal >= 8);	


/*
Subqueries in FROM 
* Restructure and transform your data 
* Prefiltering data 

Calculating aggregates of aggregates 
*Which 3 teams has the highest average of home goals scored?
1. Calculate the AVG for each team 
2. Get the 3 highest of the AVG values  


writing the subquery 
SELECT 
	t.team_ong_name AS team, 
	AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team;

Building the query 
SELECT team, home_avg 
FROM (SELECT 
		t.team_long_name AS team, 
		AVG(m.home_goal) AS home_avg
	FROM match AS m 
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id
	WHERE season = '2011/2012'
	GROUP BY team) AS subquery
ORDER BY home_avg DESC
LIMIT 3;

Things to remember 
You can create multiple subqueries in one FROM statement 
*Alias them!
*Join them!

You can join a subquery to a table in FROM 
*Include a joining columns in both tables!
*/

--Joining Subqueries in FROM 
--Building the query 
SELECT 
	-- Select the country ID and match ID
	id, 
    country_id 
FROM match
-- Filter for matches with 10 or more goals in total
WHERE (home_goal + away_goal) >= 10;

--Adding the query 
SELECT
	-- Select country name and the count match IDs
    c.name AS country_name,
    COUNT(c.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
INNER JOIN (SELECT id, country_id 
           FROM match
           -- Filter the subquery by matches with 10+ goals
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;

--Building on Subqueries in FROM 
SELECT
	-- Select country, date, home, and away goals from the subquery
    country,
    date,
    home_goal,
    away_goal
FROM 
	-- Select country name, date, and total goals in the subquery
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subq
-- Filter by total goals scored in the main query
WHERE total_goals >= 10;


/*
Selecting what?
Returns a single value 
*Including aggregate values to compare to individual values 
Used in mathematical calculations 
* Deviation from the average 

*Calculate the total matches across all seasons 
SELECT COUNT(id) FROM match; 

generating the subquery 
SELECT 
	season,
	COUNT(id) AS matches, 
	12837 as total_matches 
FROM match
GROUP BY season; 

alternate method for generating the query 
SELECT
	season,
	COUNT(id) AS matches, 
	(SELECT COUNT(id) FROM match) AS total_matches 
FROM match 
GROUP BY season; 

generating the subquery 
SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012';

calculating the number in a separate query and put it into a substatmeent 
SELECT 
	date,
	(home_goal + away_goal) AS goals,
	(home_goal + away_goal) - 2.72 AS diff
FROM match 
WHERE season = '2011/2012';


OR you can use a subquery that caluclates this value for you in your 
SELECT 
	date,
	(home_goal + away_goal) AS goals,
	(home_goal + away_goal) - 
		(SELECT AVG(home_goal + away_goal
		FROM match
		WHERE season = '2011/2012') AS diff)
FROM match 
WHERE season = '2011/2012';

Things to keep in mind when selecting subqueries 
Need to return a SINGLE value 
* Will generate an error otherwise

Make sure you have all filters in the right places 
* Properly filter both the main and the subquery!

SELECT 
	date, 
	(home_goal + away_goal) AS goals,
	(home_goal + away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		FROM match
		WHERE season = '2011/2012') AS diff
FROM match 
WHERE season = '2011/2012';
*/

--Subqueries in Select for Calculations 
SELECT 
	l.name AS league,
    -- Select and round the league's total goals
    ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (SELECT ROUND(AVG(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY l.name;

--Subqueries in Select for Calculations 
SELECT
	-- Select the league name and average goals scored
	l.name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Only include 2013/2014 results
WHERE season = '2013/2014'
GROUP BY l.name;

/*
Can include multiple subqueries in SELECT, FROM, WHERE 

SELECT 
	country_id, 
	ROUND(AVG(matches.home_goal + matches.away_goal), 2) AS avg_goals,
	(SELECT ROUND(AVG(home_goal + away_goal),2)
	FROM match WHERE season = '2013/2014') AS overall_avg
FROM (SELECT 
		id,
		home_goal,
		away_goal,
		season
		FROM match
		WHERE home_goal > 5) AS matches 
WHERE matches.season = '2013/2014'
	AND (AVG(matches.home_goal + matches.away_goal) > 
	(SELECT AVG(home_goal + away_goal)
	FROM match WHERE season = '2013/2014')
GROUP BY country_id;

Best pratice
important to line up SELECT, FROM, WHERE, and GROUP BY

SELECT	
	col1,
	col2,
	col3
FROM table1
WHERE col1= 2;

Clearly indent all of the queries
SELECT 
	date,
	hometeam_id,
	awayteam_id,
	CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
		THEN 'Chelsea home win'
	WHEN awayteam_id = 8455 AND home_goal < away_goal
		THEN 'Chelsea away win'
	WHEN hometeam_id = 8455 AND home_goal < away_goal
		THEN 'Chelsea home loss'
	WHEN awayteam_id = 8455 AND home_goal > away_goal
		THEN 'Chelsea away loss'
	WHEN (hometeam_id = 8455 OR awayteam_id = 8455)
		AND home_goal = away_goal THEN 'Chelsea Tie'
	END AS outcome
FROM match 
WHERE hometeam_id = 8455 OR awayteam_id = 8455;


it is important to know when to use a subquery 
Subqueries require computing power 
*How big is your database? 
*How big is the table you're querying from? 
Is the subquery actually necessary? 

Properly filter each subquery!
*Watch your filters!

SELECT 
	country_id, 
	ROUND(AVG(m.home_geal + m.away_goal),2) AS avg_goals, 
	(SELECT ROUND(AVG(home_goal + away_goal),2)
	FROM match WHERE season = '2013/2014') AS overall_ag
FROM match AS m
WHERE 
	m.season = '2013/2014'
	AND (AVG(m.home_goal + m.away_goal) >
		(SELECT AVG(home_goal + away_goal)
		FROM match WHERE season = '2013/2014')
GROUP BY country_id;
*/

--ALL the subqueries EVERYWHERE 
SELECT 
	-- Select the stage and average goals for each stage
	m.stage,
    ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND((SELECT AVG(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
-- Filter for the 2012/2013 season
WHERE season = '2012/2013'
-- Group by stage
GROUP BY m.stage;

--Add a subquery in FROM 
SELECT 
	-- Select the stage and average goals from the subquery
	stage,
	ROUND(avg_goals,2) AS avg_goals
FROM 
	-- Select the stage and average goals in 2012/2013
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');

--Add subquery select 
SELECT 
	-- Select the stage and average goals from s
	stage,
    ROUND(s.avg_goals,2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT AVG(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM 
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');

/*
Correlated subqueries
Uses values from the outer query to generate a resullt 
Re-run for every row generated in the final data set 
Used for advanced joining, filtering, and evaluating data 
The query above finds after the stakes get higher there is a higher than average number of goals 

Here is a correlaated query that does the same thing 
SELECT
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goal,
	(SELECT AVG(home_goal + away_goal)
	FROM match
	WHERE season = '2012/2013') AS overall_avg
FROM
	(SELECT
		stage,
		AVG(home_goal + away_goal) AS avg_goals
	FROM match
	WHERE season = '2012/2013'
	GROUP BY stage) AS s
WHERE s.avg_goals > (SELECT AVG(home_goal + away_goal)  --instead of season the outer table match stage pulls from the subquery in FROM, is HIGHER than the overall average generated subquery
					FROM match AS m
					WHERE s.stage > m.stage);
					
					
Difference between simple versus correlated subqueries 
Simple Subquery 
* Can be run independently from the main query 
* Evaluated once in the whole query 

Correlated subquery
* Dependent on the main query to execute 
* Evaluated in loops 
** Significantly slows down query runtime 

What is the average number of goals scored in each country?
SELECT
	c.name AS country,
	AVG(m.home_goal + m.away_goal)
		AS avg_goals
FROM country AS calculating
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

A correlated subquery can be used here in leu of a join to answer the same question 
SELECT
	c.name AS country,
	(SELECT
		AVG(home_goal + away_goal)
	FROM match AS m
	WHERE m.country_id = c.id)
		AS avg_goals
FROM country AS c 
GROUP BY country
*/

SELECT 
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    main.date,
    main.home_goal, 
    main.away_goal
FROM match AS main
WHERE 
	-- Filter the main query by the subquery
	(home_goal + away_goal) > 
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         -- Join the main query to the subquery in WHERE
         WHERE main.country_id = sub.country_id);
		 
		 
--correalting subqueries with multiple conditions

SELECT 
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    main.date,
    main.home_goal,
    main.away_goal
FROM match AS main
WHERE 
	-- Filter for matches with the highest number of goals scored
	(home_goal + away_goal) =
        (SELECT MAX(sub.home_goal + sub.away_goal)
         FROM match AS sub
         WHERE main.country_id = sub.country_id
               AND main.season = sub.season);

/*
Nested subqueries, sometimes the information in a database is not in the format that you need 
*Subquery inside another subquery
*Perform multiple layers of transformation 

How much did each country average differ from the overall average?
SELECT 
	c.name AS country,
	AVG(m.home_goal + m.away_goal) AS avg_goals,
	AVG(m.home_goal + m.away_goal) -
		(SELECT AVG(home_goal + away_goal)
		FROM match) AS avg_diff
FROM country AS c 
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

How does each months total goals differ from the average monthly total of goals scored?
SELECT
	EXTRACT(MONTH FROM date) AS month, --SELECT the sum of goals scored in each month, the month is querie using the EXTRACT function from the date 
	SUM(m.home_goal + m.away_goal) AS total_goals,
	SUM(m.home_goal + m.away_goal) -
	(SELECT AVG(goals)					--Can place the subquery into the second subquery to calculate an average of the values generated in the previous table giving you the average monthly goals scored. This result is a scalar subquery  
	FROM (SELECT
			EXTRACT(MONTH FROM date) AS month,
			SUM(home_goal + away_goal) AS goals
		FROM match
		GROUP BY month)) AS avg_diff
FROM match AS m
GROUP BY month

Nested subqueries can be correlated and uncorrelated 
*Or...a combination of the two
*Can reference information from the outer subquery or main query

What is each country's average goals scored in the 2011/2012 season?
SELECT
	c.name AS country,
	(SELECT AVG(home_goal + away_goal)
	FROM match AS m 
	WHERE m.country_id = c.id -- Correlates with main query
		AND id IN (
			SELECT id -- Begin inner subquery
			FROM match
			WHERE season = '2011/2012')) AS avg_goals
FROM country AS c
GROUP BY country;

*/

SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;


--Nest subqueries from
-- Select matches where a team scored 5+ goals
SELECT
	country_id,
    season,
	id
FROM match
WHERE home_goal > 5 OR away_goal > 5;


-- Count match ids
SELECT
    country_id,
    season,
    COUNT(id) AS matches
-- Set up and alias the subquery
FROM (
	SELECT
    	country_id,
    	season,
    	id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS subquery
-- Group by country_id and season
GROUP BY country_id, season;

SELECT
	c.name AS country,
    -- Calculate the average matches per season
	AVG(c.id) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
LEFT JOIN (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;

/*
When adding subqueries 
Query complexity inreases quickly!
*Information can be difficult to keep track of 
Solution the common table expression

Common Table Expressions (CTEs)
*Table declared before the main query 

Setting up with CTEs
WITH cte AS (
	SELECT col1, col2
	FROM table)
SELECT
	AVG(col1) AS avg_col
FROM cte;


SELECT	
	c.name AS country,
	COUNT(s.id) AS matches
FROM country AS c
INNER JOIN (
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) >= 10) AS s 
ON c.id = s.country_id
GROUP BY country;

Rewritten query from chapter 2 using cte

WITH s AS (
	SELECT country_id, id
	FROM matchWHERE (home_goal + away_goal) >= 10
)
SELECT
	c.name AS country,
	COUNT(s.id) AS matches
FROM country AS c 
INNER JOIN s
ON c.id = s.country_id
GROUP BY country;

All the CTEs
WITH s1 AS (
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) >= 10),
s2 AS (										--New subquery
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) <= 1
)
SELECT
	c.name AS country,
	COUNT(s1.id) AS high_scores,
	COUNT(s2.id) AS low_scores				--New column
FROM country AS c
INNER JOIN s1
ON c.id = s1.country_id
INNER JOIN s2								--New join
ON c.id = s2.counry_id
GROUP BY country;


Why use CTEs?

Execute once
*CTE is then stored in memory
*Improves query performance 
Improving organization of queries 
Referencing other CTEs
Referencing itself (SELF JOIN)
*/

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id,
  	   (home_goal + away_goal) AS goals
    FROM match
  	-- Create a list of match IDs to filter data in the CTE
    WHERE id IN (
       SELECT id  
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 8))
-- Select the league name and average of goals in the CTE
SELECT 
	l.name,
    AVG(match_list.goals)
FROM league AS l
-- Join the CTE onto the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


/*
We have covered many different methods for completing the same task 
The teqniques are not identical 
JOINS 
* Combine 2+ tables
-Simple 
operations/aggrefations

Corelatied Subqueries 
*Match subqueries & tables 
-Avoid limits of joins
-High processing 

Multiple/Nested Subqueries 
*Multi-step transofmrations
-Improve accuracy and reproducibility 

Common Table Expressions 
*Organize subqueries sequentially 
-Can reference other CTEs 

So which do I use?
Depends on your database/question
The technique that best allows your to:
-Use and resuse your queries
-Generate clear and acucrate results

Different use cases 
JOINS 
*2+ tables(What is the total sales per employee?)

Correlated Subqueries 
*Who does each employee report to in a company?

Multiple/Nested Subqueries 
*What is the average deal size closed by each sales representative in the quarter? 
 
 Common Table Expressions 
 *How did the marketing, sales, growth, & engineering team perform on key metrics?
 */
 
 SELECT 
	m.id, 
    t.team_long_name AS hometeam
-- Left join team to match
FROM match AS m
LEFT JOIN team as t
ON m.hometeam_id = team_api_id;


SELECT
	m.date,
    -- Get the home and away team names
    hometeam,
    awayteam,
    m.home_goal,
    m.away_goal
FROM match AS m

-- Join the home subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id

-- Join the away subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  -- Get the away team ID in the subquery
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;

--Get team names with correlated subqueries
SELECT
    m.date,
   (SELECT team_long_name
    FROM team AS t
    -- Connect the team to the match table
    WHERE t.team_api_id = m.hometeam_id) AS hometeam
FROM match AS m;

--Get team names with correlated subqueries 
SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     m.home_goal,
     m.away_goal
FROM match AS m;

--Get team names with CTEs
SELECT 
	-- Select match id and team long name
    m.id, 
    t.team_long_name AS hometeam
FROM match AS m
-- Join team to match using team_api_id and hometeam_id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id;

--Get team names with CTEs
-- Declare the home CTE
WITH home AS (
	SELECT m.id, t.team_long_name AS hometeam
	FROM match AS m
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id)
-- Select everything from home
SELECT *
FROM home;

WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;


/*
Working with aggregate values 
*Requires you to use GROUP BY with all non-aggregate columns 
SELECT
	country_id,
	season,
	date,
	AVG(home_goal) AS avg_home
FROM match
GROUP BY couontry_id

Produces error >> column "match.season" must appear in the GROUP BY clause or be used in an aggregate function

This error can be avoided by using window functions 
Window functions - perform caluclation on an already generated result set (a window)
*Running totals, rankings, moving averages

Query from Chapter to 
How many goals were scored in each match in 2011/2012, and how did that compare to the average? 

SELECT 
	date,
	(home_goal + away_goal) AS goals, 
	(SELECT AVG(home_goal + away_goal)
		FROM match 
		WHERE season = '2011/2012') AS overall_avg
	FROM match 
	WHERE season = '2011/2012';
	
This generates a three column table, the same results can be generated using the clause commmon to all window functions -- the OVER clause 

SELECT 
	date,
	(home_goal + away_goal) AS goals, 
	AVG(home_goal + away_goal) OVER() AS overall_avg
FROM match 
WHERE season = '2011/2012';

Can also Generate a RANK (creates a column using your data set and orders it ascending/descending)

What is the rank of matches based on number of goals scored? 
SELECT 
	date,
	(home_goal + away_goal) AS goals, 
	RANK() OVER(ORDER BY home_goal + away_goal) AS goals_rank --default rank of smallesr to largest 
FROM match 
WHERE season = '2011/2012';

SELECT 
	date,
	(home_goal + away_goal) AS goals, 
	RANK() OVER(ORDER BY home_goal + away_goal DESC) AS goals_rank --Adding descending function to reverse the order of the rank
FROM match 
WHERE season = '2011/2012';

key differences 
Processed after every part of query except ORDER BY 
-Uses information in result set rather than database 
Window funtions are available in PostgreSQL, Oracle, MySQL, SQL Server...
	... but not SQLite
*/

SELECT 
	-- Select the id, country name, season, home, and away goals
	m.id, 
    c.name AS country, 
    m.season,
	m.home_goal,
	m.away_goal,
    -- Use a window to include the aggregate average in each row
	AVG(m.home_goal + m.away_goal) OVER() AS overall_avg
FROM match AS m
LEFT JOIN country AS c ON m.country_id = c.id;

--What is OVER here? 
SELECT 
	-- Select the league name and average goals scored
    l.name AS league,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank each league according to the average goals
    RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal)) AS league_rank
FROM league AS l
LEFT JOIN match AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;


--Flip over your results
SELECT 
	-- Select the league name and average goals scored
	l.name AS league,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank leagues in descending order by average goals
    RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal) DESC) AS league_rank
FROM league AS l
LEFT JOIN match AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

/*
A partition allows you to calculate separate values for different categories established in a partition

OVER and PARTITION BY
*Calculate separate values for different categories
*Calculate different calculations in the same column 

AVG(home_goal) OVER(PARTITION BY season)


-Partition your data 
*How many goals were scored in each match, and how did that compare to the overall average? 

SELECT 
	date, 
	(home_goal + away_goal) AS goals,
	AVG(home_goal + away_goal) OVER() AS overall_avg 
FROM match; 

Howe many goals were scored in each match how did that compare to the season's average? 

SELECT 
	date, 
	(home_goal + away_goal) AS goals, 
	AVG(home_goal + away_goal) OVER(PARTITION BY season) AS season_avg 
FROM match; 

Partition can also be used to calculate values by multiple columns 
SELECT 
	c.name,
	m.season,
	(home_goal + away_goal) AS goals, 
	AVG(home_goal + away_goal)
		OVER(PARTITION BY m.season, c.name) AS season_ctry_avg
FROM country AS calculateLEFT JOIN match AS main

You can use a partition with any kind of window function 
PARTITION BY considerations 
*Can partition data by 1 or more columns 
*Can partition aggregate calculatiosn, ranks, etc.
ON c.id = m.country_id
*/

SELECT
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home' 
		 ELSE 'away' END AS warsaw_location,
    -- Calculate the average goals scored partitioned by season
    AVG(home_goal) OVER(PARTITION BY season) AS season_homeavg,
    AVG(away_goal) OVER(PARTITION BY season) AS season_awayavg
FROM match
-- Filter the data set for Legia Warszawa matches only
WHERE 
	hometeam_id = 8673 
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;


--PArtition by multiple columns
SELECT 
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home' 
         ELSE 'away' END AS warsaw_location,
	-- Calculate average goals partitioned by season and month
    AVG(home_goal) OVER(PARTITION BY season, 
         	EXTRACT(MONTH FROM date)) AS season_mo_home,
    AVG(away_goal) OVER(PARTITION BY season, 
            EXTRACT(MONTH FROM date)) AS season_mo_away
FROM match
WHERE 
	hometeam_id = 8673 
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;

/* 
A sliding window calculation can also be partitioned by one or more columns, just like a non-sliding window
Sliding windows 
*perofmr caluclation relative to the current row 
*Can be used to calculate running totals, sums, averages, etc
*Can be partitioned by one or more columns

This syntax can be used for slicing your windows functions for each row in the data set 

Sliding window keywords 
ROWS BETWEEN <start> AND <finish>

You can specify a number of key words: 

PRECEDING - used to specify the number or rows 
FOLLOWING - used to specify the number of rows 
UNBOUNDED PRECEDING - every row since the beginning of the dataset 
UNBOUNDED FOLLOWING - every row since the end of the data set in your calculations 
CURRENT ROW - want to stop your calculation at the current row

--Manchester City Home Games 
SELECT 
	date,
		home_goal,
		away_goal,
		SUM(home_goal)
			OVER(ORDER BY date ROWS BETWEEN
				UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM match
WHERE hometeam_id = 8456 AND season = '2011/2012';

--You can calculate sliding windows with a limited frame 
--Manchester City Homes Games 
SELECT date, 
	home_goal,
	away_goal,
	SUM(home_goal)
		OVER(ORDER BY date 
		ROWS BETWEEN 1 PRECEDING 
		AND CURRENT ROW) AS last 2 
FROM match
WHERE hometeam_id = 8456
	AND season = '2011/2012';
*/

--Slide to the left
SELECT 
	date,
	home_goal,
	away_goal,
    -- Create a running total and running average of home goals
     SUM(home_goal) OVER(ORDER BY date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(home_goal) OVER(ORDER BY date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM match
WHERE 
	hometeam_id = 9908 
	AND season = '2011/2012';
	
--Slide to the right
SELECT 
	-- Select the date, home goal, and away goals
	date,
    home_goal,
    away_goal,
    -- Create a running total and running average of home goals
    SUM(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_total,
    AVG(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_avg
FROM match
WHERE 
	awayteam_id = 9908 
    AND season = '2011/2012';


--Setting up the home team CTE
SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		WHEN m.home_goal < m.away_goal THEN 'MU Loss'
        ELSE 'Tie' END AS outcome
FROM match AS m
-- Left join team on the home team ID and team API id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the home team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';
	
SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		WHEN m.home_goal < m.away_goal THEN 'MU Win'
        ELSE 'Tie' END AS outcome
-- Join team table to the match table
FROM match AS m
LEFT JOIN team AS t 
ON m.awayteam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the away team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';
	
	
--Putting the CTEs together 
-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select team names, the date and goals
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal,
    m.away_goal
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND (home.team_long_name = 'Manchester United' 
           OR away.team_long_name = 'Manchester United');
		   
		   
--Add window function 
-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		   WHEN m.home_goal < m.away_goal THEN 'MU Win' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select columns and and rank the matches by date
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal, m.away_goal,
    RANK() OVER(ORDER BY ABS(home_goal - away_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
      OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));