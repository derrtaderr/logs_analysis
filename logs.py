#!/usr/bin/env python3
import psycopg2


def connect():
    #connect to the PostgreSQL database. returns a database connection.
    return psycopg2.connect("dbname = news")


def pop_articles_view():
    db = connect()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM popular_articles;")
    print("The three most popular articles of all time are:")
    print(" ")
    for(title, views) in cursor.fetchall():
        print(" {} - {} views".format(title,views))
    print (" ")
    db.commit()
    db.close()

def pop_authors_view():
    db = connect()
    cursor = db.cursor()
    cursor.execute("SELECT * FROM popular_authors;")
    print ("The most popular authors of all time are:")
    print(" ")
    for(name, views) in cursor.fetchall():
        print (" {} - {} views".format(name, views))
    print (" ")
    db.commit()
    db.close()

def day_of_errors():
    db = connect()
    cursor = db.cursor()
    cursor.execute("SELECT * from errors;")
    print("days with more than 1% of requests errors:")
    print(" ")
    for(date, percent) in cursor.fetchall():
        print (" {} - {}% errors".format(date.strftime("%B %d, %Y"), percent))
    print (" ")
    db.commit()
    db.close()

if __name__ == "__main__":
    pop_articles_view(), pop_authors_view(), day_of_errors()
