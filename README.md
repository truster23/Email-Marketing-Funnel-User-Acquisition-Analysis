# Email Marketing Campaign & User Acquisition Analysis

This project analyzes the performance of email marketing campaigns and user acquisition metrics across different countries. Using data extracted and transformed in Google BigQuery, this analysis evaluates the conversion funnel from email delivery to website visits.

### [View Interactive Dashboard in Looker Studio](https://lookerstudio.google.com/reporting/d6cbeee1-9bc3-480e-b140-f26f2938c99a)

---

## Business Objective
The goal is to identify the Top 10 most valuable countries by user base and evaluate the effectiveness of email campaigns (Open Rates and Click-Through Rates). This helps the marketing team optimize email frequency (`send_interval`) and target verified users more effectively.

## Tech Stack
* **Google BigQuery (SQL):** Advanced data modeling using multiple CTEs, `UNION ALL` for combining event streams, `LEFT JOINs`, and Window Functions (`RANK() OVER`) for dynamic cohort ranking.
* **Google Looker Studio:** Direct database connection, interactive dashboard design, funnel visualization, and time-series analysis.

## Key Insights
* **Absolute Market Dominance:** The United States is the primary market, holding a monopoly on both acquisition and engagement. It accounts for over 55% of all created accounts (~17k out of 28.8k) and receives over 70% of the total email volume (>100M emails).
* **Tier-2 Growth Opportunities:** India and Canada emerge as the most significant secondary markets. India follows the US with approximately 4,000 accounts and 20M sent emails, indicating strong potential for localized marketing efforts.
* **High Campaign Volatility:** Time-series analysis of daily sent messages shows a highly fluctuating pattern (ranging from 2k to 8k messages per day). This suggests the business relies heavily on batch promotional blasts rather than steady, automated drip campaigns.
  
## Repository Structure
* `email_campaign_analysis.sql` — The complex SQL script used to aggregate daily metrics from 7 different tables (accounts, sessions, email events) and calculate Top-10 rankings.
* `README.md` — Project documentation.
