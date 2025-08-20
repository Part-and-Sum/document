WITH google_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            campaign_status AS STRING
        ) AS status,
        campaign_advertising_channel_type AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value,
        video_views,
        engagements,
        video_completion,
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__campaign_report`
),
facebook_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            status AS STRING
        ) AS status,
        CAST (
            NULL AS STRING
        ) AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
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
            NULL AS float64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__campaign_report`
),
tiktok_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            NULL AS STRING
        ) AS status,
        CAST (
            NULL AS STRING
        ) AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
        clicks,
        impressions,
        spend,
        conversion AS conversions,
        CAST(
            NULL AS float64
        ) AS conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS float64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_tiktok_ads_dev`.`tiktok_ads__campaign_report`
),
pinterest_stats AS (
    SELECT
        DATE(date_day) AS date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            campaign_status AS STRING
        ) AS status,
        CAST (
            NULL AS STRING
        ) AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
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
            NULL AS float64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_pinterest_ads_dev`.`pinterest_ads__campaign_report`
),
bing_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            campaign_status AS STRING
        ) AS status,
        campaign_type AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
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
            NULL AS float64
        ) AS video_completion
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__campaign_report`
),
linkedin_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_group_id AS STRING
        ) AS campaign_id,
        campaign_group_name AS campaign_name,
        CAST(
            campaign_group_status AS STRING
        ) AS status,
        campaign_type AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
        clicks,
        impressions,
        cost AS spend,
        total_conversions AS conversions,
        conversion_value_in_local_currency AS conversions_value,
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
        `ps-silver-gold`.`silver_linkedin_ads_dev`.`linkedin_ads__campaign_report`
),
stackadapt_stats AS (
    SELECT
        CAST(
            date AS DATE
        ) AS date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS STRING
        ) AS campaign_id,
        campaign_name,
        CAST(
            NULL AS STRING
        ) AS status,
        CAST (
            NULL AS STRING
        ) AS campaign_type,
        CAST( NULL as STRING) as time_of_day,
        clicks,
        impressions,
        spend,
        conversions,
        CAST(
            NULL AS float64
        ) AS conversions_value,
        video_completes AS video_views,
        engagements,
        video_completion_rate AS video_completion
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