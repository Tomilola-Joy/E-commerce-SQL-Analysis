# E-commerce SQL Analysis
SQL data analysis of TradeZone e-commerce platform. Includes data cleaning, 8 business queries (customer acquisition, product performance, seller efficiency, revenue trends), and analytical memo with recommendations.

# TradeZone E-Commerce SQL Analysis

# Project Overview

A comprehensive SQL data analysis of TradeZone, a fast-growing Nigerian e-commerce platform operating across Lagos, Abuja, Kano, Port Harcourt, and Ibadan. This project identifies critical operational bottlenecks masking explosive 150% YoY growth and delivers strategic recommendations to improve customer retention and regional expansion in 2025.

# Problem Statement

TradeZone experienced explosive top-line growth but underlying operational problems threaten sustainability: customer retention is declining due to regional fulfillment delays, payment infrastructure gaps, and quality control issues on high-value products. Leadership needed data-driven insights to convert one-time buyers into repeat customers.

# Data Analysis & Methodology

# Dataset:TradeZone transactional data covering 2023-2024 across customers, sellers, orders, products, reviews, and payment methods.

# Process: 
- Data cleaning: handled NULL values, duplicates, inconsistent city formatting, and validated order totals against line items
- Validation: verified review ratings (1-5 range), product prices, and discount percentages
- 8 targeted SQL queries addressing customer acquisition, product performance, seller efficiency, revenue trends, payment preferences, and quality metrics

# Key Findings

# Finding 1: Regional Fulfillment Crisis
Top sellers in Lagos achieve 2-3 hour delivery; Kano/Port Harcourt exceed 72 hours. This correlates with 30-day conversion rates: Lagos 12%, Kano <5%.

# Finding 2: High-Value Product Quality Risk
Products rated <3.0 average ₦88,000 unit price (higher than rated products), indicating expensive items receive negative reviews. This threatens brand perception and high-value customer retention.

# Finding 3: Digital Payment Gap
Lagos: 45% Card payments. Kano: 85% Cash-on-Delivery, near-zero Mobile Money. This infrastructure gap limits scalability in Northern markets.

# Recommendations

1. **Northern Fulfillment Pilot:** Partner top 10 Kano sellers with 3PL provider, enforce 24-hour dispatch SLA. Expected outcome: reduce delivery time from 72 to 36 hours, lift repeat purchase rate from 5% to 9%.

2. **Verified High-Value Badge:** Implement quality verification for top 20 high-revenue products in low-rating category. Expected outcome: reduce negative review rate by 15% within 60-90 days.

# Deliverables

- **Data Cleaning Script** (Part_1.sql)
- **8 SQL Queries** (Q1-Q8) with business context
- **Cleaned Database Dump** (production-ready)
- **Analytical Memo** (executive summary + findings + recommendations)

# Tools Used

- **PostgreSQL** – Data cleaning, validation, and analysis
- **SQL** – Complex joins, aggregations, and conditional logic
