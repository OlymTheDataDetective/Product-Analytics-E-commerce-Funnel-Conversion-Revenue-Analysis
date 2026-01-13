🛒 E-Commerce Product Analytics: Funnel, Conversion & Revenue Analysis
📌 Project Overview

This project analyzes the end-to-end product funnel, acquisition efficiency, revenue performance, and cross-sell behavior of an e-commerce business (Maven Fuzzy Factory).
The goal is to generate data-driven insights that can support investor discussions, marketing decisions, and product strategy.

The analysis is performed using SQL (SQL Server / T-SQL) on event-level data covering website sessions, orders, pageviews, and order items.

🎯 Business Objective

Evaluate business growth and efficiency trends

Understand traffic channel performance

Measure conversion and monetization quality

Analyze product-level revenue, margin, and seasonality

Assess impact of new product launches and cross-selling

🧱 Dataset Description

The project uses the following core tables:

website_sessions – session-level traffic and acquisition data

orders – order-level transaction data

order_items – item-level revenue and cost data

website_pageviews – page-level user behavior data

🔍 Analysis Breakdown
1️⃣ Overall Business Growth

Question: How has the business grown over time?

Metrics:

Total website sessions (quarterly)

Total orders (quarterly)

Insight Enabled:

Tracks high-level demand and order growth across the business lifecycle.

2️⃣ Efficiency & Monetization Analysis

Question: Is the business becoming more efficient over time?

Metrics:

Session-to-order conversion rate

Average revenue per order

Average revenue per session

Why it matters:

Focuses on quality and efficiency, not just traffic growth.

Useful for investor readiness and profitability analysis.

3️⃣ Traffic Channel Performance

Question: Which acquisition channels are driving orders and how are they evolving?

Channels Analyzed:

Google Search – Non-Brand

Bing Search – Non-Brand

Brand Search (overall)

Organic Search

Direct Type-In Traffic

Outcome:

Quarterly order volume by channel

Identification of scalable vs high-intent channels

4️⃣ Channel Conversion Rate Trends

Question: How efficient is each channel at converting sessions into orders?

Metrics:

Quarterly session-to-order conversion rate by channel

Key Findings:

Significant conversion improvements observed in early 2013

Brand, organic, and direct traffic consistently show higher efficiency

5️⃣ Product Revenue & Margin Trends

Question: How do products contribute to revenue and margin over time?

Metrics:

Monthly revenue by product

Monthly margin by product

Total revenue and margin

Insights:

Clear seasonality patterns (Nov–Dec holiday spikes)

Product-specific demand cycles (e.g., Valentine’s season impact)

6️⃣ Product Page Funnel Analysis

Question: Has the /products page become more effective over time?

Metrics:

Sessions reaching /products page

Click-through rate to next page

Conversion rate from product page to order

Why it matters:

Measures improvements in product discovery and UX

Shows funnel optimization impact after product expansion

7️⃣ Cross-Sell Performance Analysis

Question: How well do products cross-sell after launching Product 4?

Approach:

Analyze orders since Product 4 launch (Dec 05, 2014)

Measure cross-sell frequency and rate by primary product

Key Findings:

Product 1 has the strongest cross-sell performance

Product 1 ↔ Product 4 show strong cross-sell affinity

Product 2 frequently cross-sells with Product 3

📊 Key Business Insights

Google Non-Brand is the largest traffic driver and should continue to be scaled

Brand, Organic, and Direct traffic deliver the highest conversion efficiency

Product expansion increases cross-sell opportunities

Seasonal demand patterns significantly impact revenue and margin

Funnel improvements led to measurable conversion gains over time

🛠️ Tools & Technologies

SQL Server (T-SQL)

Temporary tables & subqueries

Conditional aggregation

Funnel & cohort-style analysis

Conversion rate calculations

Revenue & margin analysis

🚀 How to Use This Project

Clone the repository

Run the SQL scripts sequentially in SQL Server

Review outputs to understand growth, efficiency, and product performance

Use insights for case studies, interviews, or portfolio presentations

📌 Ideal For

Data Analyst / Product Analyst portfolios

SQL interview preparation

Product analytics & funnel analysis practice

Business storytelling with data

📬 Author

Olympia Devi Gurumayum
Data Analyst | SQL • Product Analytics • Funnel Analysis
