-- =========================================================================
-- queries.sql - your analysis
--
-- Project 1 | SQL: From Data to Insight
-- Team:
-- Dataset:
--
-- This is a DELIVERABLE, graded on two things: the SQL, and what you wrote
-- underneath it. A query with no finding recorded is half an answer - in a
-- month you will not remember what it told you, and neither will whoever is
-- marking it.
--
-- Five queries minimum, each earning its place by answering a question you
-- wrote down in notebook 01. The aggregation should happen here, in SQL,
-- not in pandas after a SELECT *.
-- =========================================================================


-- =========================================================================
-- Q1 | RQ1: Does membership level predict purchase conversion?
-- =========================================================================
-- Hypothesis: Higher membership levels have a higher conversion rate than the lower membership levels.
-- Finding: The conversion across all membership levels is quite close, without big differences. However, Basic seems to be the highest one, not Platinum. 

SELECT
    m.membership_level AS 'Membership Level',
    COUNT(*) AS 'Total Interactions',
    COUNT(CASE WHEN i.purchase_flag = 1 THEN 1 END) AS 'Purchase Count',
    ROUND(AVG(i.purchase_flag) * 100, 2) AS 'Conversion Pct'			-- The fraction of interactions that were purchases in %
FROM interactions i
JOIN membership_levels m 
	ON i.membership_id = m.membership_id
GROUP BY m.membership_level
ORDER BY ROUND(AVG(i.purchase_flag) * 100, 2) DESC
;

-- =========================================================================
-- Q2 | RQ2: Which item categories have the highest conversion?
-- =========================================================================
-- Hypothesis: Categories like Automotive and Home Decor convert better than lower-consideration categories like Toys.
-- Finding: The Automotive category conversion is higher compared to the Toys category, however there is no big spread among the categories.

SELECT
    c.item_category AS 'Item Category',
    COUNT(*) AS 'Total Interactions',
    ROUND(AVG(i.purchase_flag) * 100, 2) AS 'Conversion Pct'
FROM interactions i
JOIN item_categories c 
	ON i.category_id = c.category_id
GROUP BY c.item_category
HAVING COUNT(*) > 500
ORDER BY ROUND(AVG(i.purchase_flag) * 100, 2) DESC
;
-- =========================================================================
-- Q3 | RQ3: Does adding an item to wishlist predict purchase?
-- =========================================================================
-- Hypothesis: Items added to a wishlist convert to purchases more than items that aren't.
-- Finding: Wishlisted items have a higher conversion, 68.8% versus 21.3% for items that were not in a wishlist.

SELECT 
	CASE WHEN wishlist_flag = 1 THEN 'In Wishlist' 
		ELSE 'Not in Wishlist'
	END AS 'Wishlist Status',
	COUNT(*) AS 'Total Interactions',
	SUM(purchase_flag) AS 'Purchase',
	ROUND(AVG(purchase_flag) * 100, 2) AS 'Conversion Pct'
FROM interactions
GROUP BY wishlist_flag
ORDER BY ROUND(AVG(purchase_flag) * 100, 2) DESC
;

-- =========================================================================
-- Q4 | RQ3 (continued): Does higher user loyalty score predict purchase?
-- =========================================================================
-- Hypothesis: Customers with a higher loyalty score purchase at a higher rate than customers with a lower score.
-- Finding: Users with higher loyalty score have higher conversions compared to medium and lower tiers.

SELECT 
	CASE 
		WHEN user_loyalty_score < 0.44 THEN 'Low'		-- scores bands are based on the finding in pandas: non-purchase median score is 0.44 and purchase median score is 0.69
		WHEN user_loyalty_score < 0.69 THEN 'Medium'
		ELSE 'High' 
	END AS 'Loyalty Score',
	COUNT(*) AS 'Total Interactions',
	ROUND(AVG(purchase_flag) * 100,  2) AS 'Conversion Pct'
FROM interactions
GROUP BY 
	CASE 
		WHEN user_loyalty_score < 0.44 THEN 'Low'
		WHEN user_loyalty_score < 0.69 THEN 'Medium'
		ELSE 'High' 
	END
ORDER BY ROUND(AVG(purchase_flag) * 100,  2) DESC
;

-- =========================================================================
-- Q5 | RQ4: Among purchased items, does item quality predict returns?
-- =========================================================================
-- Hypothesis: Lower-quality items get returned more often than higher-quality items.
-- Finding: Even though there isn't a  big difference between the item quality scores level, items with lower quality seem to have higher return rates.


SELECT
	CASE 
		WHEN item_quality_score < 0.69 THEN 'Low'
		WHEN item_quality_score < 0.74 THEN 'Medium'
		ELSE 'High'
	END AS 'Item Quality Score',
	COUNT(*) AS 'Total Purchased Items',
	SUM(return_flag) AS ' Number of Returns',
	ROUND(AVG(return_flag) * 100, 2) AS 'Return Rate'
FROM interactions
WHERE purchase_flag = 1 
GROUP BY 
	CASE 
		WHEN item_quality_score < 0.69 THEN 'Low'
		WHEN item_quality_score < 0.74 THEN 'Medium'
		ELSE 'High'
	END
ORDER BY ROUND(AVG(return_flag) * 100, 2) DESC
;

-- =========================================================================
-- Q6 | Which item categories' conversion is higher than the overall average?
-- =========================================================================
-- Hypothesis: Given the categories spread is not very big and there isn't a large number of categories, around half of them will fall over the average.
-- Finding: Four of ten categories (Automotive, Home Decor, Books, Beauty) beat the overall average conversion rate.

SELECT 
	c.item_category AS 'Category',
	ROUND(AVG(i.purchase_flag) * 100, 2) AS 'Conversion Pct'
FROM interactions i
JOIN item_categories c
	ON i.category_id = c.category_id
GROUP BY c.item_category
HAVING AVG(i.purchase_flag) > (SELECT AVG(purchase_flag) FROM interactions)
ORDER BY ROUND(AVG(i.purchase_flag) * 100, 2) DESC
;

-- =========================================================================
-- Q7 | What category has the highest return rate?
-- =========================================================================
-- Hypothesis: One category will stand out with a noticeably higher return rate than the rest.
-- Finding: Sports has the highest return rate of all the categories. 

SELECT 
	c.item_category AS 'Category',
	SUM(CASE WHEN i.return_flag = 1 THEN 1 ELSE 0 END) AS 'Return Count',
    ROUND(AVG(i.return_flag) * 100, 2) AS 'Return Rate'
FROM interactions i
JOIN item_categories c
	ON i.category_id = c.category_id
WHERE i.purchase_flag = 1
GROUP BY c.item_category
ORDER BY SUM(CASE WHEN i.return_flag = 1 THEN 1 ELSE 0 END) DESC
LIMIT 1
;

-- =========================================================================
-- Q8 | What age group has the most purchases without returns?
-- =========================================================================
-- Hypothesis: The most popular age group will also have the highest purchases without returns.
-- Finding: Age group 25-34 has the most purchases without returns. 

SELECT
    a.age_group,
    COUNT(*) AS 'Count Purchase w/o Return'
FROM interactions i
JOIN age_groups a 
	ON i.age_group_id = a.age_group_id
WHERE i.purchase_flag = 1 
AND i.return_flag = 0
GROUP BY a.age_group
ORDER BY COUNT(*) DESC
LIMIT 1
;
