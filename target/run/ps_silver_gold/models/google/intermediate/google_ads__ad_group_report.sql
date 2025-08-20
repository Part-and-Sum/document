
  
    

    create or replace table `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__ad_group_report`
      
    
    

    OPTIONS()
    as (
      

WITH stats AS (

    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_group_stats`
),
accounts AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account`
),
campaigns AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_campaign`
),
ad_groups AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_group`
),
video AS (
    SELECT
        ad_group_id,
        segments_date,
        SUM(metrics_video_views) AS video_views,
        SUM(metrics_engagements) AS engagements,
        SUM(
            metrics_video_views * metrics_video_quartile_p100_rate
        ) AS video_completion
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_video_stats`
    GROUP BY
        ad_group_id,
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
        accounts.customer_id AS account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
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
        LEFT JOIN ad_groups
        ON stats.ad_group_id = ad_groups.ad_group_id
        LEFT JOIN campaigns
        ON ad_groups.campaign_id = campaigns.campaign_id
        LEFT JOIN accounts
        ON campaigns.customer_id = accounts.customer_id
        LEFT JOIN video
        ON stats.ad_group_id = video.ad_group_id
        AND stats.segments_date = video.segments_date
        LEFT JOIN mapping
        ON CAST(
            mapping.account_id AS string
        ) = cast(campaigns.customer_id as string)
    GROUP BY
        stats.segments_date,
        accounts.account_name,
        accounts.customer_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
        video.video_views,
        video.engagements,
        video.video_completion,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
)
SELECT
    date_day,
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    NULL AS ad_group_id,
    NULL AS ad_group_name,
    NULL AS ad_group_status,
    NULL AS ad_group_type,
    spend_usd,
    clicks,
    impressions,
    conversions,
    conversions_value,
    daily_CVR_percent,
    daily_CTR_percent,
    daily_CPC_usd,
    daily_CPM_usd,
    daily_CPA_usd,
    daily_ROAS_usd,
    NULL AS video_views,
    NULL AS engagements,
    NULL AS video_completion,
    NULL AS video_view_rate_percent,
    NULL AS daily_CPV_usd,
    NULL AS daily_CPE_usd,
    NULL AS daily_VCR_percent,
    client_id,
    client_name,
    sub_client_name,
    ad_platform
FROM
    `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__PMAX_report`
UNION ALL
SELECT
    date_day,
    account_id,
    account_name,
    campaign_id,
    campaign_name,
    ad_group_id,
    ad_group_name,
    ad_group_status,
    ad_group_type,
    spend_usd,
    clicks,
    impressions,
    conversions,
    conversions_value,
    daily_CVR_percent,
    daily_CTR_percent,
    daily_CPC_usd,
    daily_CPM_usd,
    daily_CPA_usd,
    daily_ROAS_usd,
    video_views,
    engagements,
    video_completion,
    video_view_rate_percent,
    daily_CPV_usd,
    daily_CPE_usd,
    daily_VCR_percent,
    client_id,
    client_name,
    sub_client_name,
    ad_platform
FROM
    fields
    );
  