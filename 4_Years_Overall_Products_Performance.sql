/* =========================================================
E-COMMERCE PRODUCT ANALYTICS: FUNNEL CONVERSION REVENUE ANALYSIS

THE SITUATION:
Maven Fuzzy Factory is preparing for its next funding round. The objective of this project is to analyze product funnel performance and 
revenue metrics to develop a clear, data-driven narrative that can support investor discussions.

QUESTION 1: Showing the overall business growth. 
--Pulling total website session volume and order volume, trended by quarter across the life of the business.
========================================================= */

SELECT 
    YEAR(ws.created_at) AS yr,
    DATEPART(QUARTER, ws.created_at) AS qr,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY 
    YEAR(ws.created_at),
    DATEPART(QUARTER, ws.created_at)
ORDER BY 
    yr, qr;

/* 
QUESTION 2: Analyze quarterly performance since launch to evaluate efficiency improvements by calculating:

1. session-to-order conversion rate
2. average revenue per order
3. average revenue per session */

SELECT 
    YEAR(ws.created_at) AS yr,
    DATEPART(QUARTER, ws.created_at) AS qr,

    CAST(COUNT(DISTINCT o.order_id) AS FLOAT) 
        / COUNT(DISTINCT ws.website_session_id) 
        AS session_to_order_conversion_rate,

    SUM(o.price_usd) 
        / COUNT(DISTINCT o.order_id) 
        AS revenue_per_order,

    SUM(o.price_usd) 
        / COUNT(DISTINCT ws.website_session_id) 
        AS revenue_per_session
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY 
    YEAR(ws.created_at),
    DATEPART(QUARTER, ws.created_at)
ORDER BY 
    yr, qr;


/*QUESTION 3: Providing a quarterly breakdown of order volume by major traffic channels to illustrate channel growth trends, including:

1. Gsearch non-brand
2. Bsearch non-brand
3. Brand search (overall)
4. Organic search
5. Direct type-in traffic 

*/

SELECT 
    YEAR(ws.created_at) AS yr,
    DATEPART(QUARTER, ws.created_at) AS qr,

    COUNT(CASE 
            WHEN ws.utm_source = 'gsearch' 
             AND ws.utm_campaign = 'nonbrand' 
            THEN o.order_id 
          END) AS gsearch_nonbrand_orders,

    COUNT(CASE 
            WHEN ws.utm_source = 'bsearch' 
             AND ws.utm_campaign = 'nonbrand' 
            THEN o.order_id 
          END) AS bsearch_nonbrand_orders,

    COUNT(CASE 
            WHEN ws.utm_campaign = 'brand' 
            THEN o.order_id 
          END) AS brand_search_orders,

    COUNT(CASE 
            WHEN ws.utm_source IS NULL 
             AND ws.http_referer IS NOT NULL 
            THEN o.order_id 
          END) AS organic_search_orders,

    COUNT(CASE 
            WHEN ws.utm_source IS NULL 
             AND ws.http_referer IS NULL 
            THEN o.order_id 
          END) AS direct_type_in_orders
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY 
    YEAR(ws.created_at),
    DATEPART(QUARTER, ws.created_at)
ORDER BY 
    yr, qr;

/* Analyze quarterly session-to-order conversion rate trends across key acquisition channels 
and highlight periods where significant improvements or optimizations occurred.
Next, let's show the overall session-to-order conversion rate trends for those same channels, by quarter. 
Please also make a note of any periods where we made major improvements or optimizations.*/

SELECT 
    YEAR(ws.created_at) AS yr,
    DATEPART(QUARTER, ws.created_at) AS qr,

    1.0 * COUNT(CASE 
            WHEN ws.utm_source = 'gsearch' 
             AND ws.utm_campaign = 'nonbrand' 
            THEN o.order_id 
        END)
    / NULLIF(
        COUNT(CASE 
                WHEN ws.utm_source = 'gsearch' 
                 AND ws.utm_campaign = 'nonbrand' 
                THEN ws.website_session_id 
            END), 0
      ) AS gsearch_nonbrand_session_to_order,

    1.0 * COUNT(CASE 
            WHEN ws.utm_source = 'bsearch' 
             AND ws.utm_campaign = 'nonbrand' 
            THEN o.order_id 
        END)
    / NULLIF(
        COUNT(CASE 
                WHEN ws.utm_source = 'bsearch' 
                 AND ws.utm_campaign = 'nonbrand' 
                THEN ws.website_session_id 
            END), 0
      ) AS bsearch_nonbrand_session_to_order,

    1.0 * COUNT(CASE 
            WHEN ws.utm_campaign = 'brand' 
            THEN o.order_id 
        END)
    / NULLIF(
        COUNT(CASE 
                WHEN ws.utm_campaign = 'brand' 
                THEN ws.website_session_id 
            END), 0
      ) AS brand_search_session_to_order,

    1.0 * COUNT(CASE 
            WHEN ws.utm_source IS NULL 
             AND ws.http_referer IS NOT NULL 
            THEN o.order_id 
        END)
    / NULLIF(
        COUNT(CASE 
                WHEN ws.utm_source IS NULL 
                 AND ws.http_referer IS NOT NULL 
                THEN ws.website_session_id 
            END), 0
      ) AS organic_search_session_to_order,

    1.0 * COUNT(CASE 
            WHEN ws.utm_source IS NULL 
             AND ws.http_referer IS NULL 
            THEN o.order_id 
        END)
    / NULLIF(
        COUNT(CASE 
                WHEN ws.utm_source IS NULL 
                 AND ws.http_referer IS NULL 
                THEN ws.website_session_id 
            END), 0
      ) AS direct_type_in_session_to_order

FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY 
    YEAR(ws.created_at),
    DATEPART(QUARTER, ws.created_at)
ORDER BY 
    yr, qr;



-- 2013 1st quarter, for gsearch nonbrand channel, session to order rate improved from 0.0436 to 0.0612, bsearch nonbrand increased from 0.0497 to 0.0693, 
-- nonbrand increased from 0.0531 to 0.0703, organic search increased from 0.0539 to 0.0753, this is a big improvement. 

/* 
5. We've come a long way since the days of selling a single product. Let's pull monthly trending for revenue and margin by product, 
along with total sales and revenue. Note anything you notice about seasonality.
*/

SELECT 
    YEAR(o.created_at) AS [year],
    MONTH(o.created_at) AS [month],

    -- Product 1
    SUM(CASE WHEN oi.product_id = 1 THEN oi.price_usd ELSE 0 END) AS product_1_revenue,
    SUM(CASE WHEN oi.product_id = 1 THEN oi.price_usd - oi.cogs_usd ELSE 0 END) AS product_1_margin,

    -- Product 2
    SUM(CASE WHEN oi.product_id = 2 THEN oi.price_usd ELSE 0 END) AS product_2_revenue,
    SUM(CASE WHEN oi.product_id = 2 THEN oi.price_usd - oi.cogs_usd ELSE 0 END) AS product_2_margin,

    -- Product 3
    SUM(CASE WHEN oi.product_id = 3 THEN oi.price_usd ELSE 0 END) AS product_3_revenue,
    SUM(CASE WHEN oi.product_id = 3 THEN oi.price_usd - oi.cogs_usd ELSE 0 END) AS product_3_margin,

    -- Product 4
    SUM(CASE WHEN oi.product_id = 4 THEN oi.price_usd ELSE 0 END) AS product_4_revenue,
    SUM(CASE WHEN oi.product_id = 4 THEN oi.price_usd - oi.cogs_usd ELSE 0 END) AS product_4_margin,

    -- Totals
    SUM(oi.price_usd) AS total_revenue,
    SUM(oi.price_usd - oi.cogs_usd) AS total_margin

FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY 
    YEAR(o.created_at),
    MONTH(o.created_at)

ORDER BY 
    [year], [month];



-- finding: 11,12 holiday season
-- product 2, love bear, spikes in Feb, valentine's 


/* 6. Let's dive deeper into the impact of introducing new products. Now I'm pulling monthly sessions to the /product
page, and showing how the % of those sessions clicking through another page has changed over time, along with a view 
of how conversion from /products to placing an order has improved.*/

-- first, identifying all the views of the /products page
SELECT 
    website_session_id,
    website_pageview_id,
    created_at AS saw_product_page_at
INTO #product_page_pageviews
FROM website_pageviews
WHERE pageview_url = '/products';

SELECT 
    YEAR(ppp.saw_product_page_at) AS yr,
    MONTH(ppp.saw_product_page_at) AS mo,

    COUNT(DISTINCT ppp.website_session_id) AS sessions_to_product_page,
    COUNT(DISTINCT wp.website_session_id) AS clicked_to_next_page,

    CAST(COUNT(DISTINCT wp.website_session_id) AS FLOAT)
        / COUNT(DISTINCT ppp.website_session_id) AS ctr,

    COUNT(DISTINCT o.order_id) AS orders,

    CAST(COUNT(DISTINCT o.order_id) AS FLOAT)
        / COUNT(DISTINCT ppp.website_session_id) AS products_to_orders_rt

FROM #product_page_pageviews ppp

LEFT JOIN website_pageviews wp
    ON ppp.website_session_id = wp.website_session_id
   AND wp.website_pageview_id > ppp.website_pageview_id

LEFT JOIN orders o
    ON o.website_session_id = ppp.website_session_id

GROUP BY 
    YEAR(ppp.saw_product_page_at),
    MONTH(ppp.saw_product_page_at);



/*7. We made our 4th product available on Dec 05,2014.(it was previously only a cross-sell item).
I am pulling the sales data since then and showing how well each product cross-sells from one another?*/
-- STEP 1: Creating the temporary table
SELECT 
    order_id,
    primary_product_id,
    created_at AS ordered_at
INTO #primary_products
FROM orders
WHERE created_at >= '2014-12-05';

-- STEP 2: create a subquery that bringing in cross-sells
-- STEP 3: find out well each product cross-sells from one another
SELECT 
    primary_product_id,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id END) AS xsold_p1,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id END) AS xsold_p2,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id END) AS xsold_p3,
    COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id END) AS xsold_p4,

    CAST(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 1 THEN order_id END) AS FLOAT)
        / COUNT(DISTINCT order_id) AS p1_xsell_rt,

    CAST(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 2 THEN order_id END) AS FLOAT)
        / COUNT(DISTINCT order_id) AS p2_xsell_rt,

    CAST(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 3 THEN order_id END) AS FLOAT)
        / COUNT(DISTINCT order_id) AS p3_xsell_rt,

    CAST(COUNT(DISTINCT CASE WHEN cross_sell_product_id = 4 THEN order_id END) AS FLOAT)
        / COUNT(DISTINCT order_id) AS p4_xsell_rt

FROM (
    SELECT 
        pp.order_id,
        pp.primary_product_id,
        oi.product_id AS cross_sell_product_id
    FROM #primary_products pp
    LEFT JOIN order_items oi
        ON pp.order_id = oi.order_id
       AND oi.is_primary_item = 0   -- only cross-sell items
) AS primary_w_cross_sell

GROUP BY primary_product_id;

/* Findings

1. Product 1 has the most cross sales.
2. Product 1 is likely to cross sell with product 4.
3. Product 2 is the second product with most cross selling orders. 
4. Product 2 is likely to cross sell with product 3.


/* Business Insights and Recommendations
1. gsearch nonbrand has the most traffic, I would recommend the marketing could continue to bid up this channel.
2. More products could be released to increase cross selling opportunities
*/