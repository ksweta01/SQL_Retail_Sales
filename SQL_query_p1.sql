CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- DATA CLEANING

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
    
-- DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

-- How many unique categories?
SELECT COUNT(DISTINCT category) AS total_sale FROM retail_sales;

-- DATA ANALYSIS 
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
 SELECT * FROM retail_sales
 WHERE sale_date = "2022-11-05";
 
 
 -- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
 SELECT * 
FROM retail_sales 
WHERE category = 'Clothing' 
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' 
  AND quantiy >= 4;


 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 SELECT category,
 SUM(total_sale)  as net_sale,
 COUNT(*) as total_orders 
 FROM retail_sales
 GROUP BY category;
 
 
 -- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 SELECT AVG(AGE)
 FROM retail_sales
 WHERE category="Beauty";
 
 
 -- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
 SELECT * FROM retail_sales
 WHERE total_sale > 1000;
 
 
 -- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
 SELECT COUNT(transactions_id),gender
 FROM retail_sales
 GROUP BY gender,category;
 
 
 -- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
 SELECT DATE_FORMAT(sale_date,'%Y-%m') AS month_year,
 AVG(total_sale)as average_sales
 FROM retail_sales
 GROUP BY DATE_FORMAT(sale_date,'%Y-%m') 
 ORDER BY average_sales DESC
 LIMIT 1
;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id, Sum(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT customer_id) as unique_customers FROM 
retail_sales;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 11 AND 15 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 15 AND 18 THEN 'Evening'
        ELSE 'Night'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

