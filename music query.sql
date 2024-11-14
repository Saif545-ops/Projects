 --Q.1 what are top 3 values of total invoice?

 select * from invoice
 order by total desc
 limit 3;

 --Q.2 who is the senior based employee based on the job title?

 select * from employee
 order by levels desc
 limit 1

-- Q.3 which countries has most invoices?

 select count(*), billing_country
 from invoice
 group by billing_country
 order by count desc

-- Q.4 which city has the best customers? we would like to throw a pramotional music 
--festival in the city we made the most money?
 
 select sum(total) as invoice_total, billing_city 
 from invoice 
 group by billing_city 
 order by invoice_total desc

-- Q.5who is the best customer? the customer who spent the most money will 
--be declared the best customer.

 select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total)as total
 from customer
 join invoice on customer.customer_id = invoice.customer_id 
 group by customer.customer_id 
 order by total desc
 limit 1

--Q.6 write a query to return the email, first name,last name, & genre of all rock
--music listeners. return your list ordered alphabetically by email starting with A

 
 select distinct email,first_name,last_name from customer 
 join invoice on customer.customer_id = invoice.customer_id
 join invoice_line on invoice.invoice_id = invoice_line.invoice_id
 where track_id in(
     select track_id from track
     join genre on track.genre_id = genre.genre_id
     where genre.name like 'Rock'
 
 )
 order by email;

--Q.7 lets invite the artist who is written the written the most rock music in our
--dataset.write a query that the artist name and total track count of the top 10 rock brands


 select artist.artist_id, artist.name,count(artist.artist_id)as number_of_songs 
 from track
 join album on  album.album_id = track.album_id 
 join artist on   artist.artist_id = album.artist_id
 join genre on  genre.genre_id = track.genre_id
 where genre.name like 'Rock'
 group by artist.artist_id
 order by number_of_songs desc 
 limit 10;

--Q8 Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest 
--songs listed firstReturn all the track names that have a song length longer than the average 
--song length. Return the Name and Milliseconds for each track. Order by the song length with the
--longest songs listed first

 select name, milliseconds 
 from track 
 where milliseconds > (
       select AVG(milliseconds) As avg_track_length
	   from track)
 order by milliseconds desc;
 
--Q.9 Find how much amount spent by each customer on artist? Write a query to return 
--name, artist name and total spent

 With best_selling_artist As (
      select artist.artist_id as artist.name as artist_name,
	  sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	  from invoice_line 
	  join track on track.track_id = invoice_line.track_id
	  join album on album.album_id = track.album_id
	  join artist on artist.artist_id = album.artist_id 
	  Group by 1
	  order by 3 desc
	  limit 1;
 )
 SELECT c.customer id, c.first name, c.last_name, bsa.artist name,
 SUM(fl.unit_price il quantity) AS amount spent
 FROM invoice i
 JOIN customer c ON c.customer id 1.customer_id
 JOIN invoice line 11 ON il.invoice id 1. invoice_id
 JOIN track t ON t.track id 11.track id
 JOIN album alb ON alb.album_id t.album_id
 JOIN best_selling_artist bsa ON bsa.artist id alb.artist_id
 GROUP BY 1,2,3,4
 ORDER BY 5 DESC;

--Q10We want to find out the most popular music Genre for each country. Q2
--(We determine the most popular genre as the genre with the highest amount of purchases)

 WITH popular_genre AS
 (
   SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
   ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT (invoice_line.quantity) DESC) AS RowNo FROM invoice_line
   JOIN invoice ON invoice.invoice_id invoice_line.invoice_id
   JOIN customer ON customer.customer_id= invoice.customer_id
   JOIN track ON track.track_id invoice_line.track_id
   JOIN genre ON genre.genre_id = track.genre_id
   GROUP BY 2,3,4
   ORDER BY 2 ASC, 1 DESC
 )
 select * from popular_genre where rowno <= 1



 