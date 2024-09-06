USE test_db;

SELECT * FROM test_db.walmart;
-- 1.Retrieve all columns for sales made in a specific branch (e.g., Branch 'A').
SELECT * FROM walmart where Branch ='A';

-- 2. Find the total sales for each product line.
 SELECT Product_line,SUM(total) FROM walmart group by Product_line;
 
-- 3. List all sales transactions where the payment method was 'Cash'.
Select * from walmart where Payment='Cash';

-- 4.  Calculate the total gross income generated in each city. 
Select city,sum(gross_income) as total_gross_income from walmart group by City;


-- 5. Find the average rating given by customers in each branch. 
Select Branch,avg(Rating) as avg_rating from walmart group by Branch order by Branch asc;


-- 6. Determine the total quantity of each product line sold.
Select Product_line,sum(Quantity) as total_quantity from walmart group by Product_line;

-- 7. List the top 5 products by unit price. 
Select  Product_line,Unit_price from walmart order by Unit_price limit 5;


-- 8. Find sales transactions with a gross income greater than 30.
Select * from walmart where gross_income>30;

USE test_db;

-- since we have date and time column in 
-- string format we will change it in standardized format for us to easier for further analysis
desc walmart;
-- to change data format
ALTER TABLE walmart add column new_date Date, add column new_time TIME;
SET SQL_SAFE_UPDATES = 0;

-- DATE COLUMN
UPDATE walmart
SET new_date = STR_TO_DATE(Date, '%d-%m-%Y');

-- TIME COLUMN
UPDATE walmart
set new_time=STR_TO_DATE(Time,'%H:%i:%s');

desc walmart;
select Date,new_date,Time,new_time from walmart;
-- 9.  Retrieve sales transactions that occurred on weekends.
-- here in mysql we have function called DAYOFWEEK where 
-- 1 means Sunday, 2 means Monday, 3- tuesday , 4-means Wed,5-thurs,6-friday,7-Saturday
-- to find weekends we will consider Sundat and Saturday
Select * from walmart where DAYOFWEEK(new_date) in (1,7);

-- 10.  Calculate the total sales and gross income for each month. 
ALTER TABLE walmart add column month_col int;
UPDATE walmart set month_col=Month(new_date);
select Date,new_date,month_col from walmart;
Select month_col ,sum(Total) as total_sales , sum(gross_income) 
as total_gross_income from walmart group by month_col order by month_col asc;
-- OR
Select month(new_date) ,sum(Total) as total_sales , sum(gross_income) as total_gross_income 
from walmart group by month(new_date) order by month(new_date) asc;

select * from walmart;
-- 11.  Find the number of sales transactions that occurred after 6 PM.
  Select count(*) from walmart where TIME(new_time) >'18:00:00';
  
-- 12.  List the sales transactions that have a higher total than the average total of all transactions. 
Select * from walmart where Total > (select avg(Total) from walmart);
-- 13. Calculate the cumulative gross income for each branch by date. 
-- SUM(gross_income) OVER (PARTITION BY branch ORDER BY new_date) computes the running total of gross_income for each branch, ordered by new_date.
-- PARTITION BY branch ensures that the cumulative calculation is done separately for each branch.
-- ORDER BY new_date specifies the order of accumulation within each branch.

SELECT
    branch,
    new_date,
    SUM(gross_income) OVER (PARTITION BY branch ORDER BY new_date) AS cumulative_gross_income
FROM walmart
ORDER BY branch, new_date;


-- 14. Find the total cogs for each customer type in each city.
Select Customer_type ,City, sum(cogs) as total_cogs from walmart group by Customer_type ,City;


SET SQL_SAFE_UPDATES = 1;