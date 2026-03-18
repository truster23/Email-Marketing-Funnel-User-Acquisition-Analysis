-- CTE 1: Aggregating daily account creation metrics
WITH mtr_date AS (
    SELECT 
        s.date AS date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        COUNT(DISTINCT a.id) AS account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM `DA.account` a
    JOIN `DA.account_session` acs ON a.id = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
    GROUP BY date, country, send_interval, is_verified, is_unsubscribed

    UNION ALL

    -- Appending daily email engagement metrics
    SELECT 
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        0 AS account_cnt,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.account` a
    JOIN `DA.account_session` acs ON a.id = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON acs.ga_session_id = sp.ga_session_id
    JOIN `DA.email_sent` es ON a.id = es.id_account
    LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message
    GROUP BY date, country, send_interval, is_verified, is_unsubscribed
), 

-- CTE 2: Summarizing metrics by date and user properties
agg_email AS (
    SELECT 
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        SUM(account_cnt) AS account_cnt,
        SUM(sent_msg) AS sent_msg,
        SUM(open_msg) AS open_msg,
        SUM(visit_msg) AS visit_msg
    FROM mtr_date
    GROUP BY 1, 2, 3, 4, 5
),

-- CTE 3: Calculating total volumes per country for ranking
sum_country AS (
    SELECT 
        country,
        SUM(account_cnt) AS total_country_account_cnt,
        SUM(sent_msg) AS total_country_sent_cnt
    FROM agg_email
    GROUP BY country
), 

-- CTE 4: Assigning ranks to countries based on volume
rank_country AS (
    SELECT 
        country,
        total_country_account_cnt,
        total_country_sent_cnt,
        RANK() OVER (ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
        RANK() OVER (ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
    FROM sum_country
)

-- Final Selection: Filtering only Top 10 countries
SELECT 
    ag.date,
    ag.country,
    ag.send_interval,
    ag.is_verified,
    ag.is_unsubscribed,
    ag.sent_msg,
    ag.open_msg,
    ag.visit_msg,
    ag.account_cnt,
    rc.total_country_account_cnt,
    rc.total_country_sent_cnt,
    rc.rank_total_country_account_cnt,
    rc.rank_total_country_sent_cnt
FROM rank_country rc
JOIN agg_email ag ON rc.country = ag.country
WHERE rc.rank_total_country_account_cnt <= 10 
   OR rc.rank_total_country_sent_cnt <= 10;
