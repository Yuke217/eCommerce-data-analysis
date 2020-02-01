SELECT
	Year(created_at),
    WEEK(created_at),
    MIN(date(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000 -- arbitrary
GROUP BY 1,2;

SELECT
	primary_product_id,
    COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) AS count_single_item_orders,
    COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS count_two_item_orders
FROM orders

WHERE order_id BETWEEN 31000 AND 32000 -- arbitrary
GROUP BY 1;


-- Traffic Source Trending Analysis
SELECT 
		MIN(date(created_at)),
	    COUNT(Distinct website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-12'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY week(created_at);
-- The non-brand traffic does seem like it's sensitive to bid changes and volume is down

SELECT 
	device_type,
    COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders,
    COUNT(orders.order_id)/COUNT(website_sessions.website_session_id) AS session_to_order_conv_rate
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-05-11'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY device_type;

-- We shouldn't be running the same bids for our desktop and mobile traffic 

-- Analyze the trending after changing the bid strategy
SELECT 
	MIN(date(created_at)) AS week_start_date,
    COUNT(CASE WHEN device_type = "desktop" THEN website_session_id ELSE NULL END) as desktop_session,
    COUNT(CASE WHEN device_type = "mobile" THEN website_session_id ELSE NULL END) as mobile_session
    -- COUNT(DISTINCT website_session_id) AS total_sessions
FROM website_sessions
WHERE website_sessions.created_at < "2012-06-09"
	AND website_sessions.created_at > "2012-04-15"
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY
	week(created_at)