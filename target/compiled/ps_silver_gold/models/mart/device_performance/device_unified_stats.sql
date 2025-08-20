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
        ad_group_id,
        ad_group_name,
        segments_device as device_type,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value,
        video_views,
        engagements,
        video_completion
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__device_report`
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
        ad_group_id,
        ad_group_name,
        device_type,
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
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__ad_group_report`
)
SELECT
    *
FROM
    google_stats
UNION ALL
SELECT
    *
FROM
    bing_stats