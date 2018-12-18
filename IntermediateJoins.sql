-- All queries using the Chinook-DB from https://github.com/lerocha/chinook-database
-- Style guide from https://www.sqlstyle.guide/

-- Query the FirstName, LastName, Email, and Genre of all individuals who listen to Rock,
-- sorted by email ASC and does not include duplicate emails.
SELECT 
DISTINCT (cu.Email), 
	 cu.FirstName, cu.LastName, ge.Name
  FROM Customer AS cu
  JOIN Invoice AS ine
    ON cu.CustomerID = ine.CustomerID
  JOIN InvoiceLine AS il
    ON ine.InvoiceId = il.InvoiceID
  JOIN track AS tr
    ON il.TrackId = tr.TrackId
  JOIN genre AS ge
    ON tr.GenreId = ge.GenreID
   AND ge.Name = 'Rock'
 ORDER BY cu.Email;

-- Finding top artists to invite to our rock show. Shows ArtistName, Total Track Count of top 10 bands
SELECT art.ArtistId, 
	   art.Name, COUNT(al.Title) AS Total_Songs
  FROM Artist AS art
  JOIN Album AS al
    ON art.ArtistId = al.ArtistId
  JOIN Track AS tr
    ON al.AlbumId = tr.AlbumId
  JOIN Genre AS gr
    ON tr.GenreId = gr.GenreId
	   AND gr.Name = 'Rock'
 GROUP BY art.ArtistId
 ORDER BY Total_Songs DESC
 LIMIT 10;

-- Which artist has earned the most according to their InvoiceLines. 
SELECT art.Name AS Artist_Name, 
	   SUM(il.UnitPrice * il.Quantity) AS total_purchase
  FROM Artist AS art
  JOIN Album AS al
    ON art.ArtistId = al.ArtistId
  JOIN Track as tr
    ON al.AlbumId = tr.AlbumId
  JOIN InvoiceLine as il
    ON tr.TrackId = il.TrackId
  JOIN Invoice as inv
    ON il.InvoiceId = inv.InvoiceId
 GROUP BY art.Name
 ORDER BY total_purchase DESC
 LIMIT 1; 

-- From the previous query which customer spent the most on a single InvoiceLine on the highest grossing band. In this case, Iron Maiden
SELECT art.Name AS Artist_Name, 
	   SUM(il.UnitPrice * il.Quantity) AS total_purchase, cu.CustomerId, cu.FirstName, cu.LastName
  FROM Artist AS art
  JOIN Album AS al
    ON art.ArtistId = al.ArtistId
	   AND art.Name = 'Iron Maiden'
  JOIN Track as tr
    ON al.AlbumId = tr.AlbumId
  JOIN InvoiceLine as il
    ON tr.TrackId = il.TrackId
  JOIN Invoice as inv
    ON il.InvoiceId = inv.InvoiceId
  JOIN Customer as cu
    ON inv.CustomerId = cu.CustomerID
 GROUP BY cu.CustomerId
 ORDER BY total_spent DESC
 LIMIT 1;

-- Top 15 customers who only purchase Rock music
SELECT cu.CustomerId, cu.Email, cu.FirstName, cu.LastName, SUM(il.UnitPrice * il.Quantity) AS total_purchase
  FROM Customer AS cu
  JOIN Invoice AS inv
    ON cu.CustomerId = inv.CustomerId
  JOIN InvoiceLine AS il
    ON inv.InvoiceId = il.InvoiceId
  JOIN Track AS tr
    ON il.TrackId = tr.TrackID
  JOIN Genre AS ge
    ON tr.GenreId = ge.GenreID
   AND ge.Name = 'Rock'
 GROUP BY 1, ge.Name
 ORDER BY total_purchase DESC
 LIMIT 15
;

-- Top genres by total purchase amount from the media store
SELECT SUM(il.UnitPrice * il.Quantity) AS total_purchase, ge.Name
  FROM Customer AS cu
  JOIN Invoice AS inv
    ON cu.CustomerId = inv.CustomerId
  JOIN InvoiceLine AS il
    ON inv.InvoiceId = il.InvoiceId
  JOIN Track AS tr
    ON il.TrackId = tr.TrackID
  JOIN Genre AS ge
    ON tr.GenreId = ge.GenreID
 GROUP BY ge.Name
 ORDER BY total_purchase DESC
 LIMIT 5
;
