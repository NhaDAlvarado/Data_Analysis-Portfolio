# 🚗 Transportation Analysis Project

## 📌 Project Overview

Transportation affects nearly every aspect of our daily lives — from how people commute to work, to how goods are moved across cities and countries. I chose this dataset because I'm deeply interested in understanding how different modes of transportation are used and how patterns shift over time and geography. This project allowed me to blend data cleaning, analysis, and storytelling to uncover meaningful insights about transportation trends.

---

## 🎯 Objectives

- Clean and prepare raw transportation data for analysis
- Explore patterns across different transportation modes
- Answer key business and social insight questions
- Visualize findings in an intuitive and engaging Tableau dashboard

---

## 🧰 Tech Stack

- **SQL** – For initial data exploration and transformation
- **Python (Pandas, Matplotlib)** – For deeper analysis and preprocessing
- **Tableau** – For interactive dashboards and storytelling

---

## 🧹 Data Cleaning

The raw dataset contained multiple issues such as:

- Missing values in certain transport categories
- Inconsistent column naming and formatting
- Irrelevant or duplicate records
- Wide format needing pivoting for analysis

![Data Architecture](data_architecture.png)

Using **Python and Pandas**, I:

- Handled missing data using imputation techniques or exclusions where necessary
- Renamed columns for clarity
- Transformed data to long format for better analysis and visualization
- Standardized units and categories

---

## 🚧 Difficulties & Challenges

This project wasn't without its challenges. Some of the key hurdles I encountered included:

- ⚙️ **Understanding the column structure**: Column names lacked clear explanations and were inconsistently labeled.
- 🔗 **Data integration**: Joining two tables required careful key matching and handling of nulls or mismatched IDs.
- 🚛 **Vehicle type classification**: I had to infer vehicle types based on vehicle numbers, which weren't always standardized.
- 🧹 **Messy data**: Location names appeared in various formats (upper/lowercase, with or without country), which required cleaning and standardization.
- 🏷️ **Renaming vehicle types**: Many vehicle type codes needed to be mapped to user-friendly, readable labels for dashboard display.

These issues taught me to be patient, meticulous, and creative in approaching real-world data problems.

---

## 🔍 Insight Questions

Some of the core questions I sought to answer:

1. Which modes of transportation are most utilized over the years?
2. How has public transport usage evolved compared to private vehicles?
3. Are there seasonal or yearly trends in transportation preferences?
4. Which states or regions have the highest reliance on public vs. private transportation?

These questions guided my SQL and Python analysis, shaping the structure of the Tableau dashboard.

---

## 📊 Dashboard

**How my dashboard looks like:**
![Dashboard](Logistic%20Dashboard.png)

**[View Interactive Dashboard](https://public.tableau.com/app/profile/nha.alvarado/viz/LogisticsDashboard_17474321140130/LogisticsDashboard)**

**Dashboard Features:**

- Filters by year and transportation type
- Regional usage comparisons
- Trend lines and growth metrics

---

## 📈 Key Insights

- A significant shift toward **public transport** in urban areas in recent years
- Noticeable drop in **private car usage** during specific years (possibly due to external factors like fuel prices or policies)
- **Rail and bus transit** showing steady growth, especially in coastal and high-density regions
- Seasonality found in modes like **air travel and recreational transportation**

---

## 🤔 What I Learned

- Effective data storytelling requires both **technical skill** and a **user-centered design** approach
- Even seemingly clean datasets often need rigorous preprocessing
- Tableau is powerful for showcasing trends, but it’s the **right questions** that drive impactful insights
- Blending SQL, Python, and Tableau creates a well-rounded data pipeline from raw data to business decision-making

---

## 🧠 Future Improvements

- Incorporate external data sources (e.g., fuel prices, population) to enrich analysis
- Use machine learning to forecast transportation trends
- Add geospatial visualizations for regional analysis

---

Thank you for reading! This project was a great opportunity to deepen my analytical skills while working on a topic that impacts us all — how we move.
