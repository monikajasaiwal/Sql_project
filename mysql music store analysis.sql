use music_store;
show tables;
-- 1.  Who is the senior most employee based on job title?
select * from employee; 
SELECT title, last_name, first_name FROM employee
ORDER BY levels DESC
LIMIT 1
-- 2.  Which countries have the most Invoices?
 select * from invoice;
 SELECT COUNT(*) , billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY  billing_country  desc; 
-- 3. What are top 3 values of total invoice? 
select * from invoice;
SELECT MAX(total) AS max_total, billing_country FROM invoice
GROUP BY billing_country
ORDER BY max_total DESC limit 3;
-- 4. Which city has the best customers?  Return both the city name & sum of all invoice totals ?
select * from customer;
select * from invoice;
SELECT billing_city,SUM(total) AS InvoiceTotal FROM invoice
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1; 
-- 5. Who is the best customer? Write a query that returns the person who has spent the most money.
select c.customer_id, c.first_name,c.last_name ,sum(total)  as total_spent from customer c
join invoice i on c.customer_id = i.customer_id 
group by c.customer_id ,c.first_name , c.last_name
order by total_spent desc limit 1;
-- 6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
select email, first_name, last_name from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name Like "Rock"
order by email;
-- 7 .Return all the track names that have a song length longer than the average song length.Return the Name and Milliseconds for each track. Order by the song length with thelongest songs listed first
select * from track;
select name ,milliseconds from track where milliseconds >
 (select avg(milliseconds) as avg_song_length from track)
order by milliseconds desc; 
-- 8. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query
-- that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
-- 9. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
select * from customer;
select * from invoice;
SELECT c.customer_id, c.first_name,c.last_name,c.country,invoice.billing_country,SUM(invoice.total) AS total_spent
FROM customer c
JOIN invoice ON c.customer_id = invoice.customer_id
WHERE invoice.total = (SELECT MAX(total) FROM invoice)
GROUP BY c.customer_id,c.first_name,c.last_name, c.country,invoice.billing_country
ORDER BY invoice.billing_country, total_spent DESC;





