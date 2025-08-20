
  
    

    create or replace table `ps-silver-gold`.`ad_group_performance_dev`.`ad_group_unified_stats`
      
    
    

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
        CAST(
            ad_group_id AS STRING
        ) AS ad_group_id,
        ad_group_name,
        ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value,
        video_views,
        engagements,
        video_completion
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__ad_group_report`
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
            ad_set_id AS STRING
        ) AS ad_group_id,
        ad_set_name AS ad_group_name,
        CAST(
            NULL AS STRING
        ) AS ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__ad_set_report`
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
            ad_group_id AS STRING
        ) AS ad_group_id,
        ad_group_name,
        CAST(
            NULL AS STRING
        ) AS ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend,
        conversion AS conversions,
        NULL AS conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion
    FROM
        `ps-silver-gold`.`silver_tiktok_ads_dev`.`tiktok_ads__ad_group_report`
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
            ad_group_id AS STRING
        ) AS ad_group_id,
        ad_group_name,
        CAST(
            NULL AS STRING
        ) AS ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend,
        total_conversions AS conversions,
        total_conversions_value AS conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion
    FROM
        `ps-silver-gold`.`silver_pinterest_ads_dev`.`pinterest_ads__ad_group_report`
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
            ad_group_id AS STRING
        ) AS ad_group_id,
        ad_group_name,
        CAST(
            NULL AS STRING
        ) AS ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion,
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__ad_group_report`
),
stackadapt_stats AS (
    SELECT
        DATE(DATE) AS date_day,
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
            campaign_group_id AS STRING
        ) AS ad_group_id,
        campaign_group_name AS ad_group_name,
        CAST(
            NULL AS STRING
        ) AS ad_group_type,
        CAST(
            NULL AS STRING
        ) AS bid_stratagy,
        clicks,
        impressions,
        spend,
        conversions,
        NULL AS conversions_value,
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
    stackadapt_stats
    );
  