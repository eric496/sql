/**************************************************************************************************
Movie ( mID, title, year, director ) 
English: There is a movie with ID number mID, a title, a release year, and a director. 

Reviewer ( rID, name ) 
English: The reviewer with ID number rID has a certain name. 

Rating ( rID, mID, stars, ratingDate ) 
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 
***************************************************************************************************/

/*
author: Eric Wang
*/

/*Q1 Find the titles of all movies directed by Steven Spielberg.*/
SELECT title FROM Movie WHERE director = 'Steven Spielberg';

/*Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/
SELECT DISTINCT(year) FROM 
(SELECT * FROM Movie m JOIN Rating r 
ON m.mID = r.mID) mr 
WHERE mr.stars IN (4,5)
ORDER BY mr.year ASC;

/*Q3 Find the titles of all movies that have no ratings.*/
SELECT title FROM (SELECT * FROM Movie m LEFT JOIN Rating r ON m.mID = r.mID 
WHERE r.mID IS NULL);

/*Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers 
who have ratings with a NULL value for the date.*/
SELECT name FROM (SELECT * FROM Reviewer re JOIN Rating ra ON re.rID = ra.rID 
WHERE ra.ratingDate IS NULL);

/*Q5 Write a query to return the ratings data in a more readable format: 
reviewer name, movie title, stars, and ratingDate. Also, sort the data, 
first by reviewer name, then by movie title, and lastly by number of stars.*/
SELECT re.name, m.title, ra.stars, ra.ratingDate FROM Movie m JOIN
Rating ra ON m.mID = ra.mID JOIN Reviewer re
ON re.rID = ra.rID ORDER BY re.name, m.title, ra.stars;

/*Q6 For all cases where the same reviewer rated the same movie twice and 
gave it a higher rating the second time, return the reviewer's name and the 
title of the movie.*/
SELECT name, title FROM Movie m, Reviewer re, Rating r1, Rating r2
where m.mID = r1.mID AND
re.rID = r1.rID AND 
r1.rID = r2.rID AND 
r2.mID = m.mID AND
r1.stars < r2.stars AND 
r1.ratingDate < r2.ratingDate;

/*Q7 For each movie that has at least one rating, find the highest 
number of stars that movie received. Return the movie title and number 
of stars. Sort by movie title.*/
SELECT title, max(stars) FROM Movie m join 
Rating r on m.mID = r.mID GROUP BY m.mID ORDER BY m.title;

/*Q8 For each movie, return the title and the 'rating spread', that is, 
the difference between highest and lowest ratings given to that movie. 
Sort by rating spread FROM highest to lowest, then by movie title.*/
SELECT title, max(stars) - min(stars) as spread FROM Movie m join 
Rating r on m.mID = r.mID GROUP BY title ORDER BY spread DESC title;

/*Q9 Find the difference between the average rating of movies released before 
1980 and the average rating of movies released after 1980. (Make sure to 
calculate the average rating for each movie, then the average of those averages 
for movies before 1980 and movies after. Don't just calculate the overall average 
rating before and after 1980.)*/
SELECT AVG(before.avgbefore) - AVG(after.avgafter) FROM
(SELECT title, avg(stars) avgbefore FROM Movie m join 
Rating r on m.mID = r.mID GROUP BY title HAVING year < 1980) before, 
(SELECT title, avg(stars) avgafter FROM Movie m join 
Rating r on m.mID = r.mID GROUP BY title HAVING year > 1980) after