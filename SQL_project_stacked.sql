/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name 
FROM club_data.facilities
WHERE membercost != 0;

/* 
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court 
*/ 

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(name)
FROM club_data.facilities
WHERE membercost != 0;
-- Answer: 5 


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM club_data.facilities
WHERE membercost < monthlymaintenance/5;

/*
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15
			

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT*
FROM club_data.facilities
WHERE facid IN (1, 5);

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT  name,
		CASE WHEN monthlymaintenance > 100 THEN "expensive" ELSE 'cheap'
        END as 'monthlymaintenance'
FROM    club_data.facilities;

/* Another way of doing this by adding a column */
SELECT  name, monthlymaintenance,
CASE WHEN monthlymaintenance > 100 THEN "expensive"
ELSE "cheap"
END as cost
FROM club_data.facilities;



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT  surname, firstname
FROM club_data.members
WHERE memid=(SELECT max(memid) FROM club_data.members);


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


USE club_data;

SELECT DISTINCT(CONCAT(firstname,' ', surname)) AS member_name, facilities.name
FROM members 
LEFT JOIN bookings
ON members.memid = bookings.memid
RIGHT JOIN facilities 
ON bookings.facid= facilities.facid 
WHERE (facilities.name= "Tennis Court 1" OR facilities.name= "Tennis Court 2")
/* AND members.member_name != "GUEST GUEST" */
ORDER BY member_name;




/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

USE club_data;
SELECT CONCAT(members.firstname,' ', members.surname) AS member_name, facilities.guestcost, facilities.name
FROM bookings 
RIGHT JOIN members
ON members.memid = bookings.memid
RIGHT JOIN facilities 
ON bookings.facid= facilities.facid 
WHERE (facilities.guestcost > 30 or facilities.membercost > 30)
AND  (bookings.starttime >= '2012-09-14 00:00:00' AND 
       bookings.starttime <= '20130118 23:59:59') 
ORDER BY facilities.guestcost DESC;



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
USE club_data;
SELECT CONCAT(members.firstname,' ', members.surname) AS member_name, facilities.guestcost, facilities.name
FROM bookings 
RIGHT JOIN members
ON members.memid = bookings.memid
RIGHT JOIN facilities 
ON bookings.facid= facilities.facid 
WHERE (facilities.guestcost > 30 or facilities.membercost > 30) 
	IN ( `starttime` BETWEEN '2012-09-14 00:00:00' AND '20130118 23:59:59')
ORDER BY facilities.guestcost DESC;


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

USE club_data;
SELECT facilities.name, SUM( COUNT(bookings.facids !=0)* facilities.membercost, COUNT(bookings.facids !=0)* facilities.guestcost ) as TOTAL REVENUE