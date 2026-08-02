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

