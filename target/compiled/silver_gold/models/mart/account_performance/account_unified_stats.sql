WITH google_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`test_layer`.`google_ads__account_report`
        
),
facebook_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`test_layer`.`facebook_ads__account_report`
),
tiktok_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        total_conversions AS conversions,
        total_conversions_value AS conversions_value
    FROM
        `ps-silver-gold`.`test_layer`.`tiktok_ads__advertiser_report`
),
pinterest_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        total_conversions AS conversions,
        total_conversions_value AS conversions_value
    FROM
        `ps-silver-gold`.`test_layer`.`pinterest_ads__advertiser_report`
),
bing_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`test_layer`.`microsoft_ads__account_report`
)
SELECT
    *
FROM
    google_stats
UNION ALL
SELECT
    *
FROM
    facebook_stats
UNION ALL
SELECT
    *
FROM
    tiktok_stats
UNION ALL
SELECT
    *
FROM
    pinterest_stats
UNION ALL
SELECT
    *
FROM
    bing_stats