

WITH stats AS (

    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account_stats`
),
accounts AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account`
),
video AS (
    SELECT
        customer_id,
        segments_date,
        SUM(metrics_video_views) AS video_views,
        SUM(metrics_engagements) AS engagements,
        SUM(
            metrics_video_views * metrics_video_quartile_p100_rate
        ) AS video_completion
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_video_stats`
    GROUP BY
        customer_id,
        segments_date
),
mapping AS (
    SELECT
        *
    FROM
        `ps-silver-gold.mapping.mapping`
),
fields AS (
    SELECT
        stats.segments_date AS date_day,
        stats.customer_id AS account_id,
        accounts.account_name,
        ROUND(SUM(stats.metrics_cost_micros) / 1e6, 2) AS spend_usd,
        SUM(
            stats.metrics_clicks
        ) AS clicks,
        SUM(
            stats.metrics_impressions
        ) AS impressions,
        SUM(
            stats.metrics_conversions
        ) AS conversions,
        SUM(
            stats.metrics_conversions_value
        ) AS conversions_value,
        ROUND(
            safe_divide(SUM(stats.metrics_conversions), SUM(stats.metrics_clicks)) * 100,
            2
        ) AS daily_CVR_percent,
        ROUND(
            safe_divide(SUM(stats.metrics_clicks), SUM(stats.metrics_impressions)) * 100,
            2
        ) AS daily_CTR_percent,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_clicks)),
            2
        ) AS daily_CPC_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_impressions)) * 1000,
            2
        ) AS daily_CPM_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_conversions)),
            2
        ) AS daily_CPA_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_conversions_value), SUM(stats.metrics_cost_micros) / 1e6) * 100,
            2
        ) AS daily_ROAS_usd,
        video.video_views,
        video.engagements,
        video.video_completion,
        ROUND(
            safe_divide(video.video_views, SUM(stats.metrics_impressions)) * 100,
            2
        ) AS video_view_rate_percent,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, video.video_views),
            2
        ) AS daily_CPV_usd,
        ROUND(
            safe_divide(video.engagements, SUM(stats.metrics_impressions)) * 100,
            2
        ) AS daily_CPE_usd,
        ROUND(
            safe_divide(
                video.video_completion,
                video.video_views
            ) * 100,
            2
        ) AS daily_VCR_percent,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
    FROM
        stats
        LEFT JOIN accounts
        ON stats.customer_id = accounts.customer_id
        LEFT JOIN video
        ON stats.customer_id = video.customer_id
        AND stats.segments_date = video.segments_date
        LEFT JOIN mapping
        ON CAST(
            mapping.account_id AS string
        ) = cast(stats.customer_id as string)
    GROUP BY
        stats.segments_date,
        stats.customer_id,
        accounts.account_name,
        video.video_views,
        video.engagements,
        video.video_completion,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
)
SELECT
    *
FROM
    fields