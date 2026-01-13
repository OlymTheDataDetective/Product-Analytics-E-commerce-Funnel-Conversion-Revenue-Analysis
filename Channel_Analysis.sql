/* =========================================================
ANALYSIS: PAID SEARCH CHANNEL PERFORMANCE (GSEARCH vs BSEARCH)

OBJECTIVE:
Evaluate the performance of a newly launched paid search channel (bsearch)
against the existing gsearch nonbrand campaign to guide bidding decisions
and understand long-term traffic dependency.
========================================================= */


/* ---------------------------------------------------------
1. Weekly Session Trend: Gsearch vs Bsearch (Nonbrand)
Business Question:
After launching bsearch on Aug 22, how does weekly session volume compare
against gsearch nonbrand traffic?
--------------------------------------------------------- */

SELECT 
    MIN(CAST(created_at AS DATE)) AS week_start_date,
    COUNT(DISTINCT CASE 
        WHEN utm_source = 'gsearch' THEN website_session_id 
    END) AS gsearch_sessions,
    COUNT(DISTINCT CASE 
        WHEN utm_source = 'bsearch' THEN website_session_id 
    END) AS bsearch_sessions
FROM website_sessions
WHERE created_at >= '2012-08-22'
  AND created_at < '2012-11-29'
  AND utm_campaign = 'nonbrand'
GROUP BY DATEPART(YEAR, created_at), DATEPART(WEEK, created_at)
ORDER BY week_start_date;


/* ---------------------------------------------------------
2. Device Mix Analysis: Mobile Traffic Share
Business Question:
How does the percentage of mobile traffic differ between
gsearch and bsearch nonbrand campaigns?
--------------------------------------------------------- */

SELECT 
    utm_source,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE 
        WHEN device_type = 'mobile' THEN website_session_id 
    END) AS mobile_sessions,
    CAST(
        COUNT(DISTINCT CASE 
            WHEN device_type = 'mobile' THEN website_session_id 
        END) * 1.0 
        / COUNT(DISTINCT website_session_id) 
        AS DECIMAL(5,4)
    ) AS pct_mobile
FROM website_sessions
WHERE utm_campaign = 'nonbrand'
  AND created_at >= '2012-08-22'
  AND created_at < '2012-11-30'
GROUP BY utm_source;

-- Insight:
-- Gsearch drives a significantly higher share of mobile traffic compared to bsearch,
-- indicating differences in audience behavior or bidding strategy.


/* ---------------------------------------------------------
3. Conversion Rate Analysis by Device
Business Question:
Should bsearch nonbrand have similar bid levels as gsearch?
Compare session-to-order conversion rates by device type.
--------------------------------------------------------- */

SELECT 
    ws.device_type,
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    CAST(
        COUNT(DISTINCT o.order_id) * 1.0 
        / COUNT(DISTINCT ws.website_session_id) 
        AS DECIMAL(5,4)
    ) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
WHERE ws.utm_campaign = 'nonbrand'
  AND ws.created_at >= '2012-08-22'
  AND ws.created_at <= '2012-09-18'
GROUP BY ws.device_type, ws.utm_source
ORDER BY ws.device_type, ws.utm_source;

-- Insight:
-- Gsearch outperforms bsearch across both desktop and mobile devices.
-- Recommendation: Reduce bid levels for bsearch nonbrand campaigns.


/* ---------------------------------------------------------
4. Post Bid-Down Impact Analysis
Business Question:
After bidding down bsearch nonbrand on Dec 2, how did weekly
session volumes change relative to gsearch by device?
--------------------------------------------------------- */

SELECT 
    MIN(CAST(ws.created_at AS DATE)) AS week_start_date,

    COUNT(DISTINCT CASE 
        WHEN utm_source = 'gsearch' AND device_type = 'desktop' 
        THEN website_session_id 
    END) AS gsearch_desktop_sessions,

    COUNT(DISTINCT CASE 
        WHEN utm_source = 'bsearch' AND device_type = 'desktop' 
        THEN website_session_id 
    END) AS bsearch_desktop_sessions,

    CAST(
        COUNT(DISTINCT CASE 
            WHEN utm_source = 'bsearch' AND device_type = 'desktop' 
            THEN website_session_id 
        END) * 1.0
        /
        NULLIF(
            COUNT(DISTINCT CASE 
                WHEN utm_source = 'gsearch' AND device_type = 'desktop' 
                THEN website_session_id 
            END), 0
        )
        AS DECIMAL(5,4)
    ) AS bsearch_pct_of_gsearch_desktop,

    COUNT(DISTINCT CASE 
        WHEN utm_source = 'gsearch' AND device_type = 'mobile' 
        THEN website_session_id 
    END) AS gsearch_mobile_sessions,

    COUNT(DISTINCT CASE 
        WHEN utm_source = 'bsearch' AND device_type = 'mobile' 
        THEN website_session_id 
    END) AS bsearch_mobile_sessions,

    CAST(
        COUNT(DISTINCT CASE 
            WHEN utm_source = 'bsearch' AND device_type = 'mobile' 
            THEN website_session_id 
        END) * 1.0
        /
        NULLIF(
            COUNT(DISTINCT CASE 
                WHEN utm_source = 'gsearch' AND device_type = 'mobile' 
                THEN website_session_id 
            END), 0
        )
        AS DECIMAL(5,4)
    ) AS bsearch_pct_of_gsearch_mobile

FROM website_sessions ws
WHERE utm_campaign = 'nonbrand'
  AND ws.created_at >= '2012-11-04'
  AND ws.created_at < '2012-12-22'
GROUP BY DATEPART(YEAR, ws.created_at), DATEPART(WEEK, ws.created_at)
ORDER BY week_start_date;

-- Insight:
-- Bsearch traffic declined noticeably after bid reduction.
-- Seasonal effects impacted both channels, but bsearch saw a sharper drop.


/* ---------------------------------------------------------
5. Traffic Diversification Analysis
Business Question:
Are we becoming less dependent on paid nonbrand traffic?
Analyze growth of brand, direct, and organic traffic as a
percentage of paid nonbrand sessions.
--------------------------------------------------------- */

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,

    COUNT(DISTINCT CASE 
        WHEN utm_campaign = 'nonbrand' THEN website_session_id 
    END) AS nonbrand_sessions,

    COUNT(DISTINCT CASE 
        WHEN utm_campaign = 'brand' THEN website_session_id 
    END) AS brand_sessions,

    CAST(
        COUNT(DISTINCT CASE 
            WHEN utm_campaign = 'brand' THEN website_session_id 
        END) * 1.0
        /
        NULLIF(
            COUNT(DISTINCT CASE 
                WHEN utm_campaign = 'nonbrand' THEN website_session_id 
            END), 0
        )
        AS DECIMAL(5,4)
    ) AS brand_pct_of_nonbrand,

    COUNT(DISTINCT CASE 
        WHEN utm_campaign IS NULL AND http_referer IS NULL 
        THEN website_session_id 
    END) AS direct_sessions,

    CAST(
        COUNT(DISTINCT CASE 
            WHEN utm_campaign IS NULL AND http_referer IS NULL 
            THEN website_session_id 
        END) * 1.0
        /
        NULLIF(
            COUNT(DISTINCT CASE 
                WHEN utm_campaign = 'nonbrand' THEN website_session_id 
            END), 0
        )
        AS DECIMAL(5,4)
    ) AS direct_pct_of_nonbrand,

    COUNT(DISTINCT CASE 
        WHEN utm_campaign IS NULL AND http_referer IS NOT NULL 
        THEN website_session_id 
    END) AS organic_sessions,

    CAST(
        COUNT(DISTINCT CASE 
            WHEN utm_campaign IS NULL AND http_referer IS NOT NULL 
            THEN website_session_id 
        END) * 1.0
        /
        NULLIF(
            COUNT(DISTINCT CASE 
                WHEN utm_campaign = 'nonbrand' THEN website_session_id 
            END), 0
        )
        AS DECIMAL(5,4)
    ) AS organic_pct_of_nonbrand

FROM website_sessions
WHERE created_at < '2012-12-23'
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

-- Final Insight:
-- Brand, direct, and organic traffic are steadily growing as a share of paid nonbrand traffic,
-- indicating improving brand strength and reduced reliance on paid acquisition channels.
