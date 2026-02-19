drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY ,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER ,
DiscountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
)

--data exploration 
--count of rows

SELECT COUNT(*) FROM zepto
LIMIT 10;


-- sample data 
SELECT * FROM zepto 
LIMIT 10 ;


-- null values 
SELECT * FROM zepto 
WHERE name IS NULL 
OR 
category IS NULL 
OR 
mrp IS NULL 
OR 
discountPercent IS NULL 
OR 
DiscountedSellingPrice IS NULL 
OR 
weightInGms IS NULL 
OR 
availableQuantity IS NULL 
OR 
outOfStock IS NULL 
OR 
quantity IS NULL ; 





-- different product categories 

SELECT DISTINCT category 
FROM zepto
ORDER BY  category ;

-- products in stock vs outn of stock 
SELECT outOfStock ,COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name,COUNT(sku_id) as "number of SKUs"
FROM zepto 
GROUP BY name
HAVING count (sku_id)>1
ORDER BY count(sku_id) DESC ;


--data cleaning 

--products with price =0

SELECT * FROM zepto 

WHERE mrp =0 OR  discountedSellingPrice = 0 ;

DELETE FROM zepto 
WHERE mrp=0 ;



--convert paise to rupees 
UPDATE zepto 
SET mrp =mrp/100.0 ,
discountedSellingPrice = discountedSellingPrice/100.0 ;


SELECT mrp,discountedSellingPrice FROM zepto ;




--Q.1 find the top 10 best values products based on  the discount percentage 
SELECT DISTINCT name,mrp,discountPercent 
FROM zepto 
ORDER BY discountPercent  DESC 
LIMIT 10;


--Q.2 what are the  products  with high mrp but out of stock 

SELECT DISTINCT name,mrp 
FROM zepto 
WHERE outOfStock = TRUE and mrp >300
ORDER BY mrp DESC ;


--Q.3 calculate estiamted revenue for  each category 

SELECT category ,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto 
GROUP BY category 
ORDER BY total_revenue


--Q.4 find all the products where mrp >500 and discount <10%
SELECT DISTINCT name ,mrp,discountPercent
FROM zepto 
WHERE mrp> 500 AND  discountPercent <10
ORDER BY mrp DESC , discountPercent  DESC ;



--Q.5 identify the top 5 categories offering the highest average discount percentage
SELECT category ,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto 
GROUP BY category 
ORDER BY avg_discount DESC
LIMIT 5 ;

--Q.6 find the price the per gram for products above 100g and sort by best value 
SELECT DISTINCT name,weightInGms,discountedSellingPrice ,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >=100 
ORDER BY price_per_gram ;

--Q.7 group the products into catogories like low,medium,bulk 
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'	
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto  ;
	
--Q.8 what is the total inventory  weight per category 
SELECT category,	
SUM(weightInGms*availableQuantity) AS total_weight 
FROM zepto 
GROUP BY  category 
ORDER BY total_weight;


	 
	 