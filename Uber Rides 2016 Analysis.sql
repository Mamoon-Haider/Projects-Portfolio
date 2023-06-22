
SELECT *
FROM uber_rides;

----Getting data in datetime format----

UPDATE uber_rides
	SET 
		START_DATE = CONVERT(DATETIME, START_DATE, 101),
		END_DATE = CONVERT(DATETIME, END_DATE, 101);

SELECT *
FROM uber_rides;

---- Adding duration column----

ALTER TABLE uber_rides
ADD Duration TIME;

----Getting duration for each ride by subtracting end_datetime from start_datetime----

UPDATE uber_rides
SET 
	uber_rides.Duration = END_DATE - START_DATE;

----Converting duration into numbers (minutes) by applying DATEPART function to extract hour and convert it into minutes and add minutes part
----into it----

ALTER TABLE uber_rides
ADD duration_minutes AS DATEPART(HOUR, Duration)*60 + DATEPART(MINUTE, Duration);

SELECT * 
FROM uber_rides

----Getting hour, day, month, year for each ride----

ALTER TABLE uber_rides
ADD year_of_ride AS DATEPART(YEAR, START_DATE),
	day_of_ride AS DATEPART(DAY, START_DATE),
	month_of_ride AS DATEPART(MONTH, START_DATE),
	hour_of_ride AS DATEPART(HOUR, START_DATE);

SELECT *
FROM uber_rides;

ALTER TABLE uber_rides
DROP COLUMN month_of_ride;
ALTER TABLE uber_rides
DROP COLUMN day_of_rides;

ALTER TABLE uber_rides
ADD day_of_ride AS DATENAME(WEEKDAY,START_dATE);
ALTER TABLE uber_rides
ADD month_of_ride AS DATENAME(MONTH,START_DATE);

----Now let's get into further analysis to get insights of rides----
----Number of rides per month----

SELECT 
		month_of_ride ,
		COUNT(uber_rides.START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY month_of_ride
		ORDER BY Number_of_rides DESC;  ---December producded most rides, Christmas holiday activities could be the one of the possible reasons---

----Number of rides on every weekday----
SELECT 
		day_of_ride ,
		COUNT(uber_rides.START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY day_of_ride
		ORDER BY Number_of_rides DESC;    ---Friday is the busiest day for riders---

----Average distance covered on every weekday----
SELECT 
		day_of_ride,
		ROUND(AVG(uber_rides.MILES),2) as Average_miles
FROM uber_rides
		GROUP BY day_of_ride
		ORDER BY Average_miles DESC;   ---Friday has been the day when drivers got to cover longer distances for each ride, means higher AOV expected---

----let's find out the busiest hours----

SELECT 
		hour_of_ride ,
		COUNT(uber_rides.START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY hour_of_ride
		ORDER BY Number_of_rides DESC;   ----13 to 18 remained most busiest hours, means afternoon timings have highest chances to produce rides---

----which hours of the day had most rides----

SELECT 
		day_of_ride, hour_of_ride, COUNT(START_DATE) AS number_of_rides,
		ROW_number () OVER (PARTITION BY day_of_ride ORDER BY COUNT(START_DATE) DESC)
FROM uber_rides
		GROUP BY hour_of_ride,day_of_ride;      ---During all weekdays, most busy hours were after 13---

----Let's get the Day-time & Night-time rides---

ALTER TABLE uber_rides
ADD DAY_SLOT VARCHAR(20);

UPDATE uber_rides
SET DAY_SLOT = CASE
	WHEN hour_of_ride > 18 THEN 'Night Ride'
	ELSE 'DAY Ride'
	END;


SELECT 
		DAY_SLOT, 
		COUNT(START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY DAY_SLOT;

---- Comparison of day and night rides in terms of days----

SELECT 
		day_of_ride, DAY_SLOT,
		COUNT(START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY day_of_ride, DAY_SLOT
		ORDER BY Number_of_rides;        ---Friday & Sunday got highest Night_rides, whereas Tuesday & Sunday recorded highest Day_rides---

----Dividing rides into segmets like 0-10 Miles, 10-20 Miles, and so on----

ALTER TABLE uber_rides
ADD range_of_miles varchar(100);

UPDATE uber_rides
SET range_of_miles = CASE
		WHEN MILES <= 10 then '0-10'
		WHEN MILES > 10 and MILES <= 20 then '10-20'
		WHEN MILES > 20 and MILES <= 30 then '20-30'
		WHEN MILES > 30 and MILES <= 40 then '30-40'
		ELSE '>40'
		END;

----Now, let's see which of the distance range got most rides----

SELECT 
		range_of_miles,
		COUNT(START_DATE) AS number_of_rides
FROM uber_rides
		GROUP BY range_of_miles
		ORDER BY number_of_rides DESC;     ---Rides of shorter distance were more frequent, means people are more lean towards using app if they need to go somewhere near---

----Let's analyze the purpose for which people mostly use rides---

SELECT 
		CATEGORY, COUNT(START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY CATEGORY
		ORDER BY Number_of_rides DESC;  ---More than 90% of the rides were in Business category---


----Purpose of the Rides----

SELECT 
		PURPOSE, COUNT(START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY PURPOSE
		ORDER BY Number_of_rides DESC;  ---Meeting,Entertainment, Supplies are top 3 purposes of users of app---

----How many miles covered by rides of each purposes----

SELECT 
		PURPOSE, SUM(MILES) AS Total_Miles
FROM uber_rides
		GROUP BY PURPOSE
		ORDER BY Total_Miles DESC;     ---Meeting, Customer visit, Entertainment are top 3 purposes in terms of miles covered---
	

----Monthly rides based on category----

SELECT 
		month_of_ride, CATEGORY, 
		COUNT(START_DATE) AS Number_of_rides
FROM uber_rides
		GROUP BY month_of_ride,CATEGORY
		ORDER BY month_of_ride;


SELECT *
FROM uber_rides;
