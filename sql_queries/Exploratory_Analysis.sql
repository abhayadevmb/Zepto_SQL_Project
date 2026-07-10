-- Data Exploration


-- Count of Rows
SELECT COUNT(*) FROM zepto


-- Sample Data
SELECT * FROM zepto

-- Null Values
SELECT * FROM zepto
WHERE row_to_json(zepto)::text LIKE '%:null%'

-- Different Product Category
SELECT DISTINCT(category)
FROM zepto
ORDER BY category

-- Products in stock vs out of stock
SELECT COUNT(*),
	outOfStock
FROM zepto
GROUP BY outOfStock

-- Product Names present multiple times
SELECT name,
	COUNT(*) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1
ORDER  BY COUNT(*) DESC

-- Data Cleaning
SELECT *
FROM zepto
WHERE mrp = 0 OR
	discountedSellingPrice = 0

DELETE FROM zepto
WHERE mrp = 0

-- Converting Paise to Rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0

-- Answering Business Questions

-- Q1. Top 10 best value products based on the discount percentage
SELECT  DISTINCT name,
	mrp,
	discountpercent
FROM zepto
ORDER BY discountPercent DESC, name
LIMIT 10

-- Q2. Estimated Revenue for each Category
SELECT category,
	SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY SUM(mrp * quantity) DESC

-- Q3. Products with high MRP but out of stock

SELECT DISTINCT name,
	mrp
FROM zepto
WHERE mrp > 100 AND outOfStock = TRUE
ORDER BY mrp DESC

-- Q4. Find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name,
	mrp,
	discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC

-- Q5. Top 5 categories offering highest average discount percentage
SELECT category,
	ROUND(AVG(discountPercent), 2) AS avg_discount_percent
FROM zepto
GROUP BY category
ORDER BY avg_discount_percent DESC
LIMIT 5

-- Q6. Price per gram for products above 100g and sort by best value
SELECT DISTINCT name,
	weightInGms,
	(ROUND(discountedSellingPrice/weightInGms, 2)) AS price_per_gram
FROM zepto 
WHERE weightInGms >= 100
ORDER BY price_per_gram 

-- Q7. Group the products into categories like low, medium, bulk
SELECT DISTINCT name,
	weightInGms,
	CASE WHEN weightInGms < 1000 THEN 'Low'
		WHEN weightInGms < 5000 THEN 'Medium'
		ELSE 'Bulk'
	END AS weight_category
FROM zepto

-- Q10. Total inventory weight per category
SELECT category,
	SUM(weightInGms*availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight

	