

WITH stats AS (

    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_geo_stats`
),
campaigns AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_campaign`
),
accounts AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account`
),
geo AS (
    SELECT
        *
    FROM
        `secure-electron-279822.fact_lookups.google_geotarget`
),
video AS (
    SELECT
        campaign_id,
        segments_date,
        SUM(metrics_video_views) AS video_views,
        SUM(metrics_engagements) AS engagements,
        SUM(
            metrics_video_views * metrics_video_quartile_p100_rate
        ) AS video_completion
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_video_stats`
    GROUP BY
        campaign_id,
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
        campaigns.customer_id AS account_id,
        accounts.account_name,
        stats.campaign_id,
        campaigns.campaign_name,
        stats.segments_geo_target_most_specific_location AS criteria_id,
        geo.name AS geo_name,
        geo.canonical_name AS geo_target,
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
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
    FROM
        stats
        LEFT JOIN geo
        ON CAST(
            regexp_extract(
                stats.segments_geo_target_most_specific_location,
                'geoTargetConstants\\/(\\d+)'
            ) AS int64
        ) = geo.criteria_id
        LEFT JOIN campaigns
        ON stats.campaign_id = campaigns.campaign_id
        LEFT JOIN accounts
        ON stats.customer_id = accounts.customer_id
        LEFT JOIN video
        ON stats.campaign_id = video.campaign_id
        AND stats.segments_date = video.segments_date
        LEFT JOIN mapping
        ON CAST(
            mapping.account_id AS string
        ) = cast(stats.customer_id as string)
    GROUP BY
        stats.segments_date,
        accounts.account_name,
        campaigns.customer_id,
        campaigns.campaign_name,
        stats.campaign_id,
        stats.segments_geo_target_most_specific_location,
        geo.name,
        geo.canonical_name,
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