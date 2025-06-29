SELECT 'SQL is cool'
AS result;

SELECT name, birthdate
FROM people;

SELECT * /*returns all columns in 'people' file*/
FROM people;

SELECT * /*returns 10 rows of all columns in 'people' file*/
FROM people
LIMIT 10;

SELECT DISTINCT country /*returns all the unique countries in the films table*/
FROM films;

SELECT COUNT(*) /*Number of rows from the poeple table*/
FROM people;

SELECT COUNT(birthdate) /*counts the number of birthdates in the poeple table*/
FROM people;

SELECT COUNT(DISTINCT country) /* counts the unique countries from the films table */
FROM films;

SELECT title /* returns all films with the name Metropolis */
FROM films
WHERE title = 'Metropolis';

SELECT * /* selects all of the films released in 2016 */
FROM films
WHERE release_year = 2016;

SELECT COUNT(*) /* gets all of the films released before 2000 */
FROM films
WHERE release_year < 2000;

SELECT title, release_year /* selects all of the films released after 2000 */
FROM films
WHERE release_year > 2000;

SELECT name, birthdate /*selects the name and birthdate for a person born Nov. 11 1974 */
FROM people
WHERE birthdate = '1974-11-11';

SELECT COUNT(*) /*counts all films with Hindi audio */
FROM films
WHERE language = 'Hindi';

SELECT title /* will return the titles of films released between 1994 and 2000 */
FROM films
WHERE release_year > 1994
AND release_year < 2000;

SELECT * /*select films between 2000 and 2010 that are in Spanish */
FROM films
WHERE language = 'Spanish'
AND release_year > 2000
AND release_year < 2010;

SELECT title
FROM films
WHERE (release_year = 1994 OR release_year = 1995)
AND (certification = 'PG' OR certification = 'R');

SELECT title, release_year
FROM films
WHERE (release_year >= 1990 AND release_year < 2000)
AND (language = 'French' OR language = 'Spanish')
AND gross > 2000000;


SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
AND budget > 100000000
AND (language = 'Spanish' OR language = 'French');

SELECT name /* returns the name of all kids ages: 2, 4, 6, 8, and 10 */
FROM kids
WHERE age IN (2, 4, 6, 8, 10);

SELECT title, certification
FROM films
WHERE certification IN ('NC-17', 'R');

SELECT COUNT(*) /* counts all of the missing birthdates */
FROM people
WHERE birthdate IS NULL;

SELECT name /* Returns the name of all of the Spanish people that are not null */
FROM people
WHERE birthdate IS NOT NULL;

SELECT name /* % is a wildcard */
FROM companies
WHERE name LIKE 'Data%';

SELECT name /* _ underscore call also be used to find words the have altrnate letters DataCamp DataComp */
FROM companies
WHERE name LIKE 'DataC_mp';

SELECT AVG(budget) /* returns the average budget */
FROM films;

SELECT MAX(budget) /* returns the max budget */
FROM films;

SELECT MAX(gross)
FROM films
WHERE release_year BETWEEN 2000 AND 2012;

SELECT MAX(budget) AS max_budget, /* AS can be used as an alias to generate column names */
       MAX(duration) AS max_duration
FROM films;

SELECT title,
    (gross - budget) AS net_profit
FROM films;

SELECT title,
    duration / 60.0 AS duration_hours
FROM films;

SELECT COUNT(deathdate) * 100.0 / COUNT(*) AS percentage_dead
FROM people;

SELECT (MAX(release_year) - MIN(release_year)) / 10.0 AS number_of_decades
FROM films;

SELECT title --Order by sorts the values in ascending order
FROM films
ORDER BY release_year DESC;

SELECT birthdate, name
FROM people
ORDER BY birthdate;

SELECT title 
FROM films
WHERE release_year IN (2000, 2012)
ORDER BY release_year;

SELECT *
FROM films
WHERE release_year <> 2015
ORDER BY duration;

SELECT title, gross
FROM films
WHERE title LIKE 'M%'
ORDER BY title;

SELECT name
FROM people
ORDER BY name DESC;

SELECT Imdb_score, film_Id
FROM reviews
ORDER BY Imdb_score DESC;

SELECT title, duration
FROM films
ORDER BY duration DESC;

SELECT birthdate, name
FROM people
ORDER BY birthdate, name;

SELECT birthdate, name
FROM people
ORDER BY birthdate, name;

SELECT certification, release_year, title
FROM films
ORDER BY certification, release_year;

SELECT sex, count(*)
FROM employees
GROUP BY sex;

SELECT sex, count(*)
FROM employees
GROUP BY sex
ORDER BY count DESC;

SELECT release_year, count(*)
FROM films
GROUP BY release_year;

SELECT release_year, country, MAX(budget)
FROM films
GROUP BY release_year, country
ORDER BY release_year, country;

SELECT release_year
FROM films
GROUP BY release_year
HAVING COUNT(title) > 10;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY AVG(gross) DESC;

SELECT country, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross-- select country, average budget, and average gross
FROM films-- from the films table
GROUP BY country-- group by country 
HAVING COUNT(title) > 10 -- where the country has more than 10 titles
ORDER BY country-- order by country
LIMIT 5-- limit to only show 5 results
