WITH base AS (
    SELECT * 
    FROM `secure-electron-279822.linkedin_ads.monthly_ad_analytics_by_member_region`
),

macro AS (
    SELECT
        campaign_id AS campaign_id,
        month AS date_month, 
        clicks AS clicks,
        member_region AS member_region,
        impressions AS impressions,
        conversion_value_in_local_currency AS conversion_value_in_local_currency,
        cost_in_local_currency AS cost_in_local_currency,
        cost_in_usd AS cost_in_usd,
        CAST(NULL AS STRING) AS external_website_conversions,
        one_click_leads AS one_click_leads,
        CAST('' AS STRING) AS source_relation
    FROM base
),

fields AS (
    SELECT 
        source_relation,
        PARSE_DATE('%Y-%m-%d', CONCAT(SPLIT(date_month, '-')[OFFSET(0)], '-', LPAD(SPLIT(date_month, '-')[OFFSET(1)], 2, '0'), '-01')) AS date_month,
        campaign_id,
        member_region AS member_region_geo_id,
        impressions,
        clicks,
        cost_in_usd AS cost,
        COALESCE(CAST(conversion_value_in_local_currency AS FLOAT64), 0) AS conversion_value_in_local_currency,
        COALESCE(CAST(external_website_conversions AS INT64), 0) AS external_website_conversions,
        COALESCE(CAST(one_click_leads AS INT64), 0) AS one_click_leads
    FROM macro
)

SELECT * FROM fields