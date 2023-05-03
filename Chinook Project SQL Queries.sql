
----Which countries have the most Invoices?----

SELECT billing_country, Count(DISTINCT(invoice_id)) as Invoices_ordered
FROM invoice
GROUP BY billing_country
ORDER BY Count(invoice_id) DESC;

----Which city has the best customers?----

SELECT billing_city, SUM(invoice.total) as Total_Revenue
FROM invoice
GROUP BY billing_city
ORDER BY SUM(invoice.total) DESC
LIMIT 10;

----Who is the best customer?----

SELECT customer.customer_id,  customer.first_name || ' ' || customer.last_name as Customer_Name  ,SUM(invoice.total) as Money_Spent
FROM customer JOIN 
invoice on customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(invoice.total) DESC;

----Use your query to return the email, first name, last name, and Genre of all Rock Music----

SELECT DISTINCT customer.customer_id, customer.first_name || ' ' || customer.last_name as Customer_Name, customer.email, genre.name as Music
FROM customer 
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id 
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY customer.customer_id
ORDER BY customer.email ASC;


----Who is writing the rock music?----

SELECT artist.artist_id, artist.name , COUNT(genre.name) as Songs
FROM track 
JOIN genre ON track.genre_id = genre.genre_id
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
WHERE genre.name = 'Rock'
GROUP BY artist.name
ORDER BY count(genre.name) DESC
LIMIT 10;


---- find which artist has earned the most according to the InvoiceLines?----

SELECT artist.name, 
ROUND(SUM(invoice_line.unit_price* invoice_line.quantity),2) as Earnings
FROM artist
	JOIN album ON artist.artist_id = album.artist_id
	JOIN track ON album.album_id = track.album_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
GROUP BY artist.name
ORDER BY Earnings DESC
LIMIT 12;


----Customers who have spent most on Queen----

SELECT 	customer.first_name || ' ' || customer.last_name as Customer_Name, 
		ROUND(SUM(invoice_line.unit_price*invoice_line.quantity),2) as Amount_spent
FROM 
	artist
	JOIN album ON artist.artist_id = album.artist_id
	JOIN track ON album.album_id = track.album_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
	JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
	JOIN customer ON invoice.customer_id = customer.customer_id
WHERE artist.name = 'Queen'
GROUP BY Customer_Name
ORDER BY Amount_spent DESC
LIMIT 5;	

----We want to find out the most popular music Genre for each country. We determine the ---- 
----most popular genre as the genre with the highest amount of purchases. ----
----Write a query that  returns each country along with the top Genre. ----
----For countries where the maximum number of purchases is shared, return all Genres----

--STEP-1 Rank the most popular Genre for each country using dense rank --
-- To do this, connect IL to I to get Country for each product-genre by further linking it to the 
-- genre, and then group by country with genre name. Give ranking for most count of each genre in each country--
--STEP-2 Just limit the results until ranking 3, it will give top 3 genre for each country--

SELECT 	b.country, b.Genre_Name, b.Purchases, b.Ranking	
FROM (
SELECT  
		customer.country , 
		genre.name as Genre_Name, SUM(invoice_line.quantity) as Purchases,
		dense_rank () OVER ( PARTITION BY customer.country ORDER BY SUM(invoice_line.quantity) DESC) as Ranking
FROM 
	genre
	JOIN track ON genre.genre_id = track.genre_id
	JOIN invoice_line ON track.track_id = invoice_line.track_id
	JOIN invoice ON invoice_line.invoice_id = invoice.invoice_id
	JOIN customer ON invoice.customer_id = customer.customer_id
GROUP BY customer.country, genre.name ) b
WHERE b.Ranking = 1;


----Return all the track names that have a song length longer than the average song length.----

SELECT  track.name, 
		track.milliseconds as Song_length, (SELECT AVG(track.milliseconds) FROM track) as Average_length
FROM 	track
WHERE track.milliseconds > Average_length
ORDER BY track.milliseconds DESC;

----Write a query that determines the customer that has spent the most on music for each country----

SELECT c.customer_id, c.Customer_Name, c.country, c.Money_Spent, c.Ranking
FROM (
SELECT  customer.customer_id, 
		customer.first_name || ' ' || customer.last_name as Customer_Name,
		customer.country,
		SUM(invoice.total) as Money_Spent,
		dense_rank () OVER (PARTITION BY customer.country ORDER BY SUM(invoice.total)) as Ranking
FROM 
	 customer
	 JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.country, Customer_Name, customer.customer_id) c
WHERE c.Ranking = 1;




SELECT *
FROM invoice_line;












