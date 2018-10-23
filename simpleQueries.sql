-- All queries using the Chinook-DB from https://github.com/lerocha/chinook-database
-- Style guide from https://www.sqlstyle.guide/

-- Query for finding the amount of invoices by BillingCountry, grouped by country in descending order. 
SELECT BillingCountry, 
	   COUNT(CustomerID) AS Invoices
  FROM Invoice
 GROUP BY BillingCountry
 ORDER BY Invoices DESC;

-- Finding the largest invoice for an individual city in order to plan an event
SELECT SUM(Total) AS Largest_Invoice, 
	   BillingCity
  FROM Invoice
 GROUP BY BillingCity
 ORDER BY Largest_Invoice desc
 LIMIT 1;

-- Finding the top customer in order to thank them for their continued business
SELECT Customer.CustomerId AS c_Id, 
	   FirstName, Email, SUM(Total) AS total_spent
  FROM Customer
  JOIN Invoice
    ON Customer.CustomerId = Invoice.CustomerId
 GROUP BY Customer.CustomerID
 ORDER BY total_spent DESC
 LIMIT 1;
