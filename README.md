# Logs Analysis Project #


## DESCRIPTION #
This project was designed to answer three database question about a newspaper's website traffic. Those questions were:

- What are the most popular three articles of all time?
- Who are the most popular article authors of all time?
- On which days did more than 1% of requests lead to errors?

## The Set up ##
To run this properly you will need a vagrantfile and two SQL scripts to set up the environment.
follow this steps to get started:
1. Download [VAGRANT](https://www.vagrantup.com/) and install.
2. Download [VirtualBox](https://www.virtualbox.org/) and install.
3. Download the data [HERE](https://d17h27t6h515a5.cloudfront.net/topher/2016/August/57b5f748_newsdata/newsdata.zip). You will need to unzip this file after downloading it. The file inside is called newsdata.sql. Put this file into the vagrant directory.
4. ` cd ` into `logs`
```sh
$ cd logs
```
5. Now setup Vagrant.
```sh
$ vagrant up
```
6. log into Vagrant.
```sh
$ vagrant ssh
```
7. navigate your way to the Vagrant files.
```sh
cd /vagrant
```
8. Now populate the database with the news data via the SQL script.
```sh
$ psql -d news -f newsdata.sql
```
9. Set up the views needed to query the database
```sh
$ psql -d news -f views.sql
```
10. Now run the logs.py
```sh
$ python3 logs.py
```

## Expected Results ##
```sh
The three most popular articles of all time are:

 Candidate is jerk, alleges rival - 338647 views
 Bears love berries, alleges bear - 253801 views
 Bad things gone, say good people - 170098 views

 The most popular authors of all time are:

 Ursula La Multa - 507594 views
 Rudolf von Treppenwitz - 423457 views
 Anonymous Contributor - 170098 views
 Markoff Chaney - 84557 views

days with more than 1% of requests errors:

 July 17, 2016 - 2.26% errors
 ```
 ## Views ##
 The most popular articles limited to three.
 ```sh
 CREATE VIEW popular_articles AS
SELECT title, count(title) AS views
FROM articles, log
Where log.path Like CONCAT('%', articles.slug)
GROUP BY title
ORDER BY views DESC
limit 3;
```
The most popular authors listed in descending order.
```sh
CREATE VIEW popular_authors AS
SELECT name, count(title) AS views
FROM articles, authors, log
Where authors.id = articles.author
And log.path LIKE CONCAT('%', articles.slug)
GROUP BY name
ORDER BY views DESC;
```
the dates with the most error requests in descending order.
```sh
Create View error_requests AS
Select count(*) as errors, date(time) AS date
FROM log
WHERE status = '404 NOT FOUND'
GROUP BY date
ORDER BY errors DESC;
```
all the requests from the log table
```sh
Create View requests AS
Select count(*) as requests, date(time) AS date
FROM log
GROUP BY date
ORDER BY requests DESC;
```
Gives a percent to the error requests for each date.
```sh
Create View percent AS
SELECT requests.date,
round((100.0*error_requests.errors)/requests.requests,2) AS percent
FROM requests, error_requests
WHERE error_requests.date = requests.date
GROUP BY requests.date, error_requests.errors, requests.requests;
```
Gives the date of where there were more than 1% of error requests.
```sh
Create View errors AS
SELECT *
FROM percent
WHERE percent.percent >1
ORDER BY percent.percent DESC;
```

