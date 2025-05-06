# Logistics Transportation Analytics

## 📌 Motivation

India's logistics sector wastes ~$50B annually due to inefficiencies (World Bank). This project analyzes real GPS and shipment data to:

- Identify operational bottlenecks
- Quantify cost of delays
- Optimize fleet utilization

Having witnessed trucks idling for hours at Chennai warehouses, I wanted to apply data skills to solve tangible problems.

## 🛠️ Tools & Approach

### Data Cleaning (SQL)

- Standardized 500K+ GPS pings across 3 provider formats
- Handled nulls in `Planned_ETA` vs `actual_eta`
- Calculated delay minutes and distance efficiencies

### Analysis (SQL)

- Route performance benchmarking
- Vehicle type efficiency comparison
- Driver performance scoring

### Visualization (Tableau)

**How my dashboard look like:**
![Dashboard](dashboard.png)

**[View Interactive Dashboard](https://public.tableau.com/app/profile/nha.alvarado/vizzes)**  
📍 Route heatmaps with delay hotspots  
🚛 Vehicle utilization matrices  
📅 On-time delivery trend analysis

## 🔍 Key Learnings

1. **Short-haul paradox**: Sub-100km trips had 3x more idle time than long-haul
2. **Friday effect**: 28% more delays on Fridays (verified p<0.05)
3. **Hidden capacity**: 19% of trips could consolidate with 2hr window grouping
