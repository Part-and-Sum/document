
  
    

    create or replace table `ps-silver-gold`.`geo_performance_dev`.`geo_unified_stats`
      
    
    

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
        TRIM(SPLIT(geo_target, ',') [SAFE_OFFSET(2)]) AS country,
        TRIM(SPLIT(geo_target, ',') [SAFE_OFFSET(1)]) AS region,
        CAST(
            NULL AS STRING
        ) AS dma,
        TRIM(SPLIT(geo_target, ',') [SAFE_OFFSET(0)]) AS city_area,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value,
        video_views,
        engagements,
        video_completion
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__DMA_report`
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
            NULL AS STRING
        ) AS campaign_id,
        CAST(
            NULL AS STRING
        ) AS campaign_name,
        CAST(
            NULL AS STRING
        ) AS country,
        region,
        CAST(
            NULL AS STRING
        ) AS dma,
        CAST(
            NULL AS STRING
        ) AS city,
        clicks,
        impressions,
        spend,
        conversions,
        NULL AS conversions_value,
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
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__region_report`
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
        CAST(
            NULL AS STRING
        ) AS campaign_name,
        country_name AS country,
        CAST(
            NULL AS STRING
        ) AS region,
        CAST(
            NULL AS STRING
        ) AS dma,
        CAST(
            NULL AS STRING
        ) AS city,
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
        `ps-silver-gold`.`silver_pinterest_ads_dev`.`pinterest_ads__campaign_country_report`
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
        country AS country,
        CAST(
            NULL AS STRING
        ) AS region,
        CAST(
            NULL AS STRING
        ) AS dma,
        CAST(
            NULL AS STRING
        ) AS city,
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
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__campaign_region_report`
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
    pinterest_stats
UNION ALL
SELECT
    *
FROM
    bing_stats
    );
  