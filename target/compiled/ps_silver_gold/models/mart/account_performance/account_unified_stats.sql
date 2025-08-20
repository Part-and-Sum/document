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
        conversions_value,
        video_views,
        engagements,
        video_completion
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__account_report`
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
        conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__account_report`
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
        conversion AS conversions,
        CAST(
            NULL AS numeric
        ) AS conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_tiktok_ads_dev`.`tiktok_ads__advertiser_report`
),
pinterest_stats AS (
    SELECT
        DATE(date_day) AS date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        total_conversions AS conversions,
        total_conversions_value AS conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_pinterest_ads_dev`.`pinterest_ads__advertiser_report`
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
        conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__account_report`
),
linkedin_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        cost AS spend,
        total_conversions AS conversions,
        CAST(
            NULL AS numeric
        ) AS conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_linkedin_ads_dev`.`linkedin_ads__account_report`
),
stackadapt_stats AS (
    SELECT
        DATE(DATE) AS date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        clicks,
        impressions,
        spend,
        conversions,
        CAST(
            NULL AS numeric
        ) AS conversions_value,
        video_start AS video_views,
        engagements,
        video_completes AS video_completion
    FROM
        `ps-silver-gold`.`silver_stackadapt_ads_dev`.`unified_data`
    WHERE
        ad_platform = 'stackadapt'
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
UNION ALL
SELECT
    *
FROM
    linkedin_stats
UNION ALL
SELECT
    *
FROM
    stackadapt_stats