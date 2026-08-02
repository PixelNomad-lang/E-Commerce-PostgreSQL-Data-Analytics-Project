-- Q1 Total number of customers find karo.
Select Count(*)  from customers;
-----------------------------------------------
--Q2 Count no of customer from different city 
SELECT 
    city_name,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city_name;

----------------------------------------------------
-- Q3 How to  get  total revenue  ----
Select 
  SUM (quantity * price) as total_revenue
from orders;

------------------------------------------------------

