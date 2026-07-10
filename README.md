# Zepto SQL Project

## Project Overview
This project turns the Zepto v2 product catalog into a practical SQL analysis workflow for understanding pricing, availability, and inventory efficiency. The queries focus on the operational questions that matter in a quick-commerce setting: which products are attractive on value, which SKUs are at risk of lost sales due to stockouts, and how inventory is distributed across categories.

## Database Setup & Schema
The analysis is designed for PostgreSQL in pgAdmin. The workflow starts by creating a staging table for the Zepto catalog and then running the exploratory SQL queries against that table.

### Environment
- Database: PostgreSQL
- Client: pgAdmin 4
- Source file: data/zepto_v2.csv

### Schema Blueprint

| Table | Purpose | Key Columns | Data Types |
| --- | --- | --- | --- |
| zepto | Main product-level catalog table used for analysis | sku_id, category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity | SERIAL, VARCHAR, NUMERIC, INTEGER, BOOLEAN |

### Relationship Notes
- This version uses a single-table structure rather than a normalized star schema.
- The table acts as a product inventory snapshot, so the analysis is centered on product-level merchandising and stock decisions rather than transactional order history.
- No foreign keys are defined in the current schema; the data is intentionally kept simple for direct SQL exploration.

## Core Analysis & SQL Techniques
The SQL scripts do more than describe the dataset; they convert raw catalog data into decisions.

### 1. Data quality checks and issue detection
The initial queries profile the table by counting rows, sampling records, checking for null-like values, and identifying duplicate product names. That matters because a catalog with repeated names or inconsistent values can distort both inventory and pricing reports.

### 2. Cleaning choices that improve business readability
The script removes rows with zero MRP values and converts values from paise to rupees for both MRP and discounted selling price. This is a practical cleaning step because the raw values are not directly usable for business interpretation unless normalized into a human-readable currency.

### 3. Aggregation for commercial decision-making
The analysis uses grouped aggregates to estimate category-level revenue potential, compare average discounts across categories, and measure inventory weight by category. These are not just academic SQL exercises; they help answer questions like where revenue is concentrated and where stock is heavy.

### 4. Conditional logic and SKU segmentation
Case statements are used to classify products by weight into low, medium, and bulk buckets. That supports practical merchandising and logistics decisions, especially for dark-store operations where weight and pack size affect handling effort.

## Key Business Metrics
The queries are built to produce operationally useful KPIs and insights.

| Metric | SQL Focus | Business Value |
| --- | --- | --- |
| Best-value products | Top discount percentages and price-sensitive SKUs | Helps identify products worth promoting or featuring more prominently |
| Category revenue potential | discountedSellingPrice × availableQuantity by category | Supports inventory prioritization and category-level planning |
| High-ticket stockout risk | High MRP products marked out of stock | Highlights revenue at risk and items that need immediate replenishment |
| Inventory efficiency | Weight-based categories and total inventory weight | Useful for warehouse capacity planning and fulfillment efficiency |

## Business Question Results
The SQL workflow produces a set of concrete, decision-ready outputs. The examples below reflect the results from the business-question queries in [sql_queries/Exploratory_Analysis.sql](sql_queries/Exploratory_Analysis.sql).

### Q1. Best-value products
| Product | MRP | Discount |
| --- | ---: | ---: |
| Dukes Waffy Chocolate Wafers | ₹45.00 | 51% |
| Dukes Waffy Orange Wafers | ₹45.00 | 51% |
| Dukes Waffy Strawberry Wafers | ₹45.00 | 51% |
| Ceres Foods Fish Mustard Instant Liquid Masala | ₹220.00 | 50% |

### Q2. Revenue potential by category
| Category | Estimated Revenue |
| --- | ---: |
| Cooking Essentials | ₹337,369.00 |
| Munchies | ₹337,369.00 |
| Paan Corner | ₹270,849.00 |
| Personal Care | ₹270,849.00 |

### Q3. High-MRP products currently out of stock
| Product | MRP |
| --- | ---: |
| Patanjali Cow's Ghee | ₹565.00 |
| MamyPoko Pants Standard Diapers, Extra Large (12 - 17 kg) | ₹399.00 |
| Aashirvaad Atta With Mutigrains | ₹315.00 |
| Everest Kashmiri Lal Chilli Powder | ₹310.00 |

### Q4. High-MRP products with low discounting
| Product | MRP | Discount |
| --- | ---: | ---: |
| Dhara Kachi Ghani Mustard Oil Jar | ₹1,250.00 | 8% |
| Saffola Gold (Jar) | ₹1,240.00 | 0% |
| Fortune Rice Bran Health Oil (Jar) | ₹1,050.00 | 1% |
| Fortune Soyabean Oil | ₹1,005.00 | 0% |

### Q5. Highest average discount by category
| Category | Average Discount |
| --- | ---: |
| Fruits & Vegetables | 15.46% |
| Meats, Fish & Eggs | 11.03% |
| Ice Cream & Desserts | 8.32% |
| Packaged Food | 8.32% |

### Q6. Lowest price-per-gram items
| Product | Weight | Price per Gram |
| --- | ---: | ---: |
| Onion | 1000g | ₹0.02 |
| Vicks Cough Drops Menthol | 1160g | ₹0.02 |
| Tata Salt | 1000g | ₹0.02 |
| Aashirvaad Iodised Salt | 1000g | ₹0.02 |

### Q7. Weight-based product buckets
| Product | Weight | Bucket |
| --- | ---: | --- |
| Onion | 1000g | Medium |
| Tomato Hybrid | 1000g | Medium |
| Tender Coconut | 58g | Low |
| Coriander Leaves | 100g | Low |

### Q10. Inventory weight by category
| Category | Total Inventory Weight |
| --- | ---: |
| Cooking Essentials | 1,404,654g |
| Munchies | 1,404,654g |
| Home & Cleaning | 373,161g |
| Personal Care | 348,187g |

## How to Run
1. Clone this repository to your local machine.
2. Open pgAdmin and create a new PostgreSQL database.
3. Run the SQL from [sql_queries/create_table.sql](sql_queries/create_table.sql) to create the zepto table.
4. Import [data/zepto_v2.csv](data/zepto_v2.csv) into the zepto table using the column names from the schema.
5. Run the queries in [sql_queries/Exploratory_Analysis.sql](sql_queries/Exploratory_Analysis.sql) to inspect the data, apply cleaning steps, and generate the business metrics.

## Notes
This repository is intentionally lightweight and focused on a single source of truth: the Zepto product catalog. It is best used as a starting point for deeper analytics, including order history, customer behavior, and demand forecasting.
