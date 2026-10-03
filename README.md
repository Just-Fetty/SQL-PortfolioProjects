# Nashville Housing SQL Analysis

## Project Overview

This project demonstrates SQL querying and data analysis skills using the Nashville Housing dataset. The analysis explores real estate market composition, pricing trends across locations, and identifies premium properties that exceed city averages using advanced SQL techniques.

## Dataset

- **Source:** Nashville Housing market data
- **Total Records:** 56,373 properties
- **Date Range:** 2013-2024
- **Database:** PortfolioProject.dbo.NashvilleHousing
- **Key Fields:** PropertySplitAddress, PropertySplitCity, SalePrice, SaleDate, LandUse, Bedrooms

### Query Techniques Used:

- **Aggregation Functions:** COUNT, AVG, MIN, MAX
- **Filtering & Sorting:** WHERE, ORDER BY, TOP
- **Grouping:** GROUP BY with multiple aggregates
- **Joins:** INNER JOIN for data correlation
- **CTEs (Common Table Expressions):** WITH clause for complex multi-step analysis
- **Date Functions:** YEAR() for temporal analysis
- **Aliases:** Table and column aliasing for clarity and ambiguity resolution

## Queries & Findings

### Query 1: Data Overview

Establishes baseline understanding of the dataset through fundamental aggregations.

**Queries:**

- Total property count
- Sales date range (MIN/MAX)
- Average sale price across all properties
- Property distribution by land use type

**Key Finding:** 56,373 total properties with diverse land use types, primary focus on single-family residential.

---

### Query 2: Price Analysis

Analyzes pricing patterns through multiple dimensions including property rankings and bedroom-based segmentation.

**Queries:**

- Top 100 most expensive properties by address
- Average price by number of bedrooms
- Properties sold by year (2014 and 2013 comparison)

**Key Finding:** 3-4 bedroom homes command premium prices with highest market demand. Prices range from entry-level to $14M+ luxury segment.

---

### Query 3: Location Insights

Examines market performance across cities and addresses to identify regional pricing patterns.

**Queries:**

- Average price and count by land use type
- Top 100 locations by sales volume and price
- City-level analysis showing average prices and transaction volume

**Key Finding:** Nashville dominates with ~40,000 sales and $366K average price. Secondary markets (Brentwood, Goodlettsville) show strong premium pricing in specific segments.

---

### Query 4: Price Outliers (Advanced)

Uses CTEs and JOINs to identify premium properties priced 20%+ above their city's average.

**Technique:**

1. Creates temporary result set (CTE) calculating city averages
2. Joins main table back to CTE using city as key
3. Filters for properties exceeding 120% of city average

**Key Finding:** Goodlettsville and Nashville have properties commanding significant premiums (20-102% above city average), indicating premium neighborhoods and investment opportunities.
