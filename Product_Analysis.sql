/* Monthly Business Performance (Sales, Revenue, Margin)

1. Monthly business performance overview.
Pulling monthly trends for:
- Number of sales
- Total revenue
- Total margin
*/

SELECT 
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mon,
    COUNT(DISTINCT order_id) AS num_of_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM orders
WHERE created_at < '2013-01-04'
GROUP BY 
    YEAR(created_at),
    MONTH(created_at)
ORDER BY 
    yr, mon;



/* Impact of New Product Launch (Jan 06, 2013)

2. After launching a new product on Jan 06, 2013,
analyzing monthly performance including:
- Sessions
- Orders
- Conversion rate
- Revenue per session
- Product-wise order distribution
*/

SELECT 
    YEAR(ws.created_at) AS yr,
    MONTH(ws.created_at) AS mon,
    COUNT(DISTINCT ws.website_session_id) AS monthly_sessions,
    COUNT(DISTINCT o.order_id) AS num_orders,

    1.0 * COUNT(DISTINCT o.order_id) 
        / COUNT(DISTINCT ws.website_session_id) AS conv_rate,

    ROUND(
        1.0 * SUM(o.price_usd) / COUNT(DISTINCT ws.website_session_id), 2
    ) AS revenue_per_session,

    COUNT(CASE WHEN o.primary_product_id = 1 THEN o.order_id END) AS product_one_orders,
    COUNT(CASE WHEN o.primary_product_id = 2 THEN o.order_id END) AS product_two_orders

FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2012-04-01' AND '2013-04-05'
GROUP BY 
    YEAR(ws.created_at),
    MONTH(ws.created_at)
ORDER BY 
    yr, mon;



/* 
3. Products Page Clickthrough Analysis (Pre vs Post Launch)

Step 1: Identify /products pageviews and tag pre vs post product launch 
*/

SELECT 
    wp.website_session_id,
    wp.website_pageview_id,
    wp.created_at,
    CASE 
        WHEN wp.created_at BETWEEN DATEADD(MONTH, -3, '2013-01-06') AND '2013-01-06'
            THEN 'A.Pre_Product_2'
        WHEN wp.created_at BETWEEN '2013-01-06' AND DATEADD(MONTH, 3, '2013-01-06')
            THEN 'B.Post_Product_2'
    END AS time_period
INTO #products_pageviews
FROM website_pageviews wp
WHERE wp.pageview_url = '/products'
  AND wp.created_at BETWEEN DATEADD(MONTH, -3, '2013-01-06')
                        AND DATEADD(MONTH, 3, '2013-01-06');

--Step 2: Identify the next pageview after /products

SELECT 
    pp.time_period,
    pp.website_session_id,
    pp.website_pageview_id,
    MIN(wp.website_pageview_id) AS min_next_pageview_id
INTO #sessions_w_next_pageview_id
FROM #products_pageviews pp
LEFT JOIN website_pageviews wp
    ON pp.website_session_id = wp.website_session_id
   AND wp.website_pageview_id > pp.website_pageview_id
GROUP BY 
    pp.time_period,
    pp.website_session_id,
    pp.website_pageview_id;

-- Step 3: Capture next page URL

SELECT 
    sp.time_period,
    sp.website_session_id,
    wp.pageview_url AS next_pageview_url
INTO #sessions_w_next_pageview_url
FROM #sessions_w_next_pageview_id sp
LEFT JOIN website_pageviews wp
    ON wp.website_pageview_id = sp.min_next_pageview_id;

-- Step 4: Compare click behavior pre vs post product launch

SELECT 
    time_period,
    COUNT(DISTINCT website_session_id) AS sessions,

    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL 
                        THEN website_session_id END) AS clicked_next_page,

    1.0 * COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL 
                              THEN website_session_id END)
        / COUNT(DISTINCT website_session_id) AS clickthrough_rate,

    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' 
                        THEN website_session_id END) AS to_mrfuzzy,

    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' 
                        THEN website_session_id END) AS to_lovebear

FROM #sessions_w_next_pageview_url
GROUP BY time_period;




/*  Product Conversion Funnel Comparison

4. Comparing conversion funnels for each product
(from product page ? purchase)
*/

SELECT 
    website_pageview_id,
    created_at,
    website_session_id,
    CASE 
        WHEN pageview_url = '/the-forever-love-bear' THEN 'lovebear'
        WHEN pageview_url = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
    END AS product_seen
INTO #session_id_seen_product
FROM website_pageviews
WHERE created_at BETWEEN '2013-01-06' AND '2013-04-10'
  AND pageview_url IN ('/the-forever-love-bear', '/the-original-mr-fuzzy');


/* Cross-Sell Feature Impact (Pre vs Post)

Cart clickthrough rate remained stable after cross-sell launch.
Products per order, AOV, revenue, and revenue per cart session increased significantly. 
*/



/* 
Portfolio Expansion (Birthday Bear Launch)

6. Measuring impact of launching the 3rd product (Birthday Bear)
using a pre vs post analysis
*/

SELECT 
    CASE 
        WHEN ws.created_at < '2013-12-12' THEN 'A.Pre_Birthday_Bear'
        ELSE 'B.Post_Birthday_Bear'
    END AS time_period,

    1.0 * COUNT(DISTINCT o.order_id)
        / COUNT(DISTINCT ws.website_session_id) AS conv_rate,

    1.0 * SUM(o.price_usd)
        / COUNT(DISTINCT o.order_id) AS avg_order_value,

    1.0 * SUM(o.items_purchased)
        / COUNT(DISTINCT o.order_id) AS products_per_order,

    1.0 * SUM(o.price_usd)
        / COUNT(DISTINCT ws.website_session_id) AS revenue_per_session

FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 
    CASE 
        WHEN ws.created_at < '2013-12-12' THEN 'A.Pre_Birthday_Bear'
        ELSE 'B.Post_Birthday_Bear'
    END;

 -- All key performance metrics improved after launching the third product.



/* Product Quality & Refund Analysis

7. Analyzing refund rates after supplier change in Sep 2014
to validate product quality improvement
*/

SELECT 
    yr,
    mo,

    COUNT(CASE WHEN product_id = 1 THEN order_item_id END) AS p1_orders,
    1.0 * COUNT(CASE WHEN product_id = 1 THEN return_order_item_id END)
        / NULLIF(COUNT(CASE WHEN product_id = 1 THEN order_item_id END), 0) AS p1_refund_rt,

    COUNT(CASE WHEN product_id = 2 THEN order_item_id END) AS p2_orders,
    1.0 * COUNT(CASE WHEN product_id = 2 THEN return_order_item_id END)
        / NULLIF(COUNT(CASE WHEN product_id = 2 THEN order_item_id END), 0) AS p2_refund_rt,

    COUNT(CASE WHEN product_id = 3 THEN order_item_id END) AS p3_orders,
    1.0 * COUNT(CASE WHEN product_id = 3 THEN return_order_item_id END)
        / NULLIF(COUNT(CASE WHEN product_id = 3 THEN order_item_id END), 0) AS p3_refund_rt,

    COUNT(CASE WHEN product_id = 4 THEN order_item_id END) AS p4_orders,
    1.0 * COUNT(CASE WHEN product_id = 4 THEN return_order_item_id END)
        / NULLIF(COUNT(CASE WHEN product_id = 4 THEN order_item_id END), 0) AS p4_refund_rt

FROM (
    SELECT 
        YEAR(oi.created_at) AS yr,
        MONTH(oi.created_at) AS mo,
        oi.product_id,
        oi.order_item_id,
        oir.order_item_id AS return_order_item_id
    FROM order_items oi
    LEFT JOIN order_item_refunds oir
        ON oi.order_item_id = oir.order_item_id
    WHERE oi.created_at < '2014-10-15'
) item_refunds
GROUP BY 
    yr, mo
ORDER BY 
    yr, mo;


