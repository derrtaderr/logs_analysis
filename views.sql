--Behavior of View: Keeps track of the most popular articles
--Inputs: articles and log tables
--Outputs: The most popular articles limited to top 3.
CREATE VIEW popular_articles AS
SELECT title, count(title) AS views
FROM articles, log
Where log.path Like CONCAT('%', articles.slug)
GROUP BY title
ORDER BY views DESC
limit 3;

--Behavior of View: Keeps track of the most popular authors
--Input: Authors, Articles and Log tables
--Output: the most popular authors listed in descending order.
CREATE VIEW popular_authors AS
SELECT name, count(title) AS views
FROM articles, authors, log
Where authors.id = articles.author
And log.path LIKE CONCAT('%', articles.slug)
GROUP BY name
ORDER BY views DESC;

--Behavior of View: Finds the date with most error requests.
--Input: log table
--Output: the dates with the most error requests in descending order.
Create View error_requests AS
Select count(*) as errors, date(time) AS date
FROM log
WHERE status = '404 NOT FOUND'
GROUP BY date
ORDER BY errors DESC;

--Behavior of View: gathers all the request from the log (202 & 404)
--Input: log
--Output: all the requests from the log table
Create View requests AS
Select count(*) as requests, date(time) AS date
FROM log
GROUP BY date
ORDER BY requests DESC;

--Behavior of View: breaks down the error requests into a percentage for each date.
--Input: requests, error_requests
--Output: Gives a percent to the error requests for each date.
Create View percent AS
SELECT requests.date,
round((100.0*error_requests.errors)/requests.requests,2) AS percent
FROM requests, error_requests
WHERE error_requests.date = requests.date
GROUP BY requests.date, error_requests.errors, requests.requests;

--Behavior of View: tells which day had more than 1% of requests lead to errors
--Input: Percent
--Output: Gives the date of where there were more than 1% of error requests.
Create View errors AS
SELECT *
FROM percent
WHERE percent.percent >1
ORDER BY percent.percent DESC;



