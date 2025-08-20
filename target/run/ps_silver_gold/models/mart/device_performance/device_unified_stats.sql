
  
    

    create or replace table `ps-silver-gold`.`device_performance_dev`.`device_unified_stats`
      
    
    

    OPTIONS()
    as (
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
        daily_CVR_percent AS cvr,
        daily_CTR_percent AS ctr,
        daily_CPC_usd AS cpc,
        daily_CPM_usd AS cpm,
        daily_CPA_usd AS cpa,
        daily_ROAS_usd AS roas,
        video_views,
        engagements,
        video_completion,
        daily_CPV_usd AS cpv,
        daily_CPE_usd AS cpe,
        daily_VCR_percent AS vcr
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
        ROUND(safe_divide(conversions, clicks) * 100, 2) AS cvr,
        ROUND(safe_divide(clicks, impressions) * 100, 2) AS ctr,
        ROUND(safe_divide(spend, clicks), 2) AS cpc,
        ROUND(safe_divide(spend, impressions) * 1000, 2) AS cpm,
        ROUND(safe_divide(spend, conversions), 2) AS cpa,
        ROUND(safe_divide(conversions_value, spend), 2) AS roas,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS float64
        ) AS video_completion,
        CAST(
            NULL AS float64
        ) AS cpv,
        CAST(
            NULL AS float64
        ) AS cpe,
        CAST(
            NULL AS float64
        ) AS vcr
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
    );
  