SELECT 
    name
FROM
    club_data.facilities
WHERE
    membercost != 0;


/* Q2: How many facilities do not charge a fee to members? */

SELECT 
    COUNT(name)
FROM
    club_data.facilities
WHERE
    membercost = 0;
-- Answer: 4 

SELECT 
    facid, name, membercost, monthlymaintenance
FROM
    club_data.facilities
WHERE
    membercost < monthlymaintenance / 5;



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT 
    *
FROM
    club_data.facilities
WHERE
    (facid = 1 OR facid = 5)	;

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT 
    name,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END AS 'monthlymaintenance'
FROM
    club_data.facilities;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT 
    surname, firstname
FROM
    club_data.members
WHERE
    memid = (SELECT 
            MAX(memid)
        FROM
            club_data.members);


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT
    (CONCAT(firstname, ' ', surname)) AS member_name,
    facilities.name
FROM
    club_data.members
        LEFT JOIN
    bookings ON members.memid = bookings.memid
        RIGHT JOIN
    facilities ON bookings.facid = facilities.facid
WHERE
    facilities.name LIKE '%tennis%court%'
ORDER BY member_name;

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */



SELECT DISTINCT
    (CONCAT(firstname, ' ', surname)) AS member_name,
    CASE
        WHEN members.memid = 0 THEN guestcost * 2
        WHEN members.memid != 0 THEN membercost
        ELSE membercost
    END AS newcost,
    facilities.name
FROM
    club_data.facilities,
    club_data.members,
    club_data.bookings
WHERE
    facilities.facid = bookings.facid
        AND bookings.memid = members.memid
        AND DATE(starttime) = '2012-09-14'
HAVING newcost > 30
ORDER BY newcost DESC;
