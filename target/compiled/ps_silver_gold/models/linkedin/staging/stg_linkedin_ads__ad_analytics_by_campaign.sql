WITH base AS (
    SELECT * 
    FROM `secure-electron-279822.linkedin_ads.ad_analytics_by_campaign`
),

macro AS (
    SELECT
        campaign_id AS campaign_id,
        clicks AS clicks,
        cost_in_local_currency AS cost_in_local_currency,
        cost_in_usd AS cost_in_usd,
        day AS day,
        impressions AS impressions,
        conversion_value_in_local_currency AS conversion_value_in_local_currency,
        external_website_conversions AS external_website_conversions,
        one_click_leads AS one_click_leads,
        CAST('' AS STRING) AS source_relation
    FROM base
),

fields AS (
    SELECT 
        source_relation,
        DATE(day) AS date_day,
        campaign_id,
        clicks,
        impressions,
        cost_in_usd AS cost,
        COALESCE(CAST(conversion_value_in_local_currency AS FLOAT64), 0) AS conversion_value_in_local_currency,
        COALESCE(CAST(external_website_conversions AS INT64), 0) AS external_website_conversions,
        COALESCE(CAST(one_click_leads AS INT64), 0) AS one_click_leads
    FROM macro
)

SELECT *
FROM fields