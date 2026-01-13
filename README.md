# 🛒 E-Commerce Product Analytics  
## Funnel, Conversion & Revenue Analysis

## 📌 Project Overview
This project analyzes the **end-to-end product funnel, acquisition efficiency, revenue performance, and cross-sell behavior** of an e-commerce business (Maven Fuzzy Factory).

The objective is to build a **data-driven narrative** that supports **investor discussions, marketing decisions, and product strategy** using SQL-based analytics.

---

## 🎯 Business Objectives
- Track **business growth** over time
- Measure **conversion and monetization efficiency**
- Analyze **traffic channel performance**
- Evaluate **product-level revenue, margin, and seasonality**
- Assess **cross-sell impact after new product launches**

---

## 🧱 Dataset Description
The analysis is performed using the following tables:

- `website_sessions` – session-level acquisition data  
- `orders` – order-level transaction data  
- `order_items` – item-level revenue and cost data  
- `website_pageviews` – page-level user behavior data  

---

## 🔍 Analysis Breakdown

### 1️⃣ Overall Business Growth
**Metrics:**
- Quarterly website sessions
- Quarterly order volume

**Purpose:**  
Understand long-term demand growth and business scale.

---

### 2️⃣ Efficiency & Monetization Analysis
**Metrics:**
- Session-to-order conversion rate  
- Average revenue per order  
- Average revenue per session  

**Purpose:**  
Evaluate whether the business is becoming **more efficient and higher quality**, not just bigger.

---

### 3️⃣ Traffic Channel Performance
**Channels Analyzed:**
- Google Search – Non-Brand  
- Bing Search – Non-Brand  
- Brand Search (overall)  
- Organic Search  
- Direct Type-In Traffic  

**Purpose:**  
Identify which acquisition channels drive growth and how their contributions change over time.

---

### 4️⃣ Channel Conversion Rate Trends
**Metrics:**
- Quarterly session-to-order conversion rate by channel  

**Purpose:**  
Compare **acquisition quality** across channels and highlight optimization periods.

---

### 5️⃣ Product Revenue & Margin Trends
**Metrics:**
- Monthly revenue by product  
- Monthly margin by product  
- Total revenue and margin  

**Insights:**
- Clear holiday seasonality (Nov–Dec)
- Product-specific demand cycles (e.g., Valentine’s impact)

---

### 6️⃣ Product Page Funnel Analysis
**Metrics:**
- Sessions reaching `/products` page  
- Click-through rate to next page  
- Conversion rate from product page to order  

**Purpose:**  
Measure improvements in **product discovery and funnel efficiency** over time.

---

### 7️⃣ Cross-Sell Performance Analysis
**Context:**  
Product 4 was launched on **Dec 05, 2014** (previously cross-sell only).

**Metrics:**
- Cross-sell frequency by primary product  
- Cross-sell rate per product  

**Key Findings:**
- Product 1 has the strongest cross-sell performance  
- Product 1 ↔ Product 4 show strong affinity  
- Product 2 frequently cross-sells with Product 3  

---

## 📊 Key Business Insights
- Google Non-Brand is the largest traffic driver and should continue to scale
- Brand, Organic, and Direct channels show the highest conversion efficiency
- Product expansion increases cross-sell opportunities
- Funnel optimizations led to measurable conversion improvements
- Seasonality plays a significant role in revenue and margin trends

---

## 🛠️ Tools & Technologies
- SQL Server (T-SQL)
- Temporary tables & subqueries
- Conditional aggregation
- Funnel & conversion analysis
- Revenue & margin calculations

---

## 🚀 How to Use This Project
1. Clone the repository  
2. Run the SQL scripts sequentially in SQL Server  
3. Review outputs to understand growth, efficiency, and product performance  
4. Use insights for case studies, interviews, or portfolio presentations  

---

## 📌 Ideal For
- Data Analyst / Product Analyst portfolios  
- SQL interview preparation  
- Product analytics & funnel analysis practice  
- Business storytelling with data  

---

## 👤 Author
**Olympia Gurumayum**  
Data Analyst | SQL • Product Analytics • Funnel Analysis
