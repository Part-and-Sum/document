
  
    

    create or replace table `ps-silver-gold`.`keyword_performance_dev`.`keyword_unified_stats`
      
    
    

    OPTIONS()
    as (
      WITH google_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        keyword_id AS keyword_id,
        keyword_text AS keyword_text,
        CAST(
            NULL AS STRING
        ) AS final_url,
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
        daily_ROAS_usd AS roas
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__keyword_report`
),
facebook_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_set_id AS ad_group_id,
        ad_set_name AS ad_group_name,
        creative_id AS keyword_id,
        creative_name AS keyword_text,
        base_url AS final_url,
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
        ROUND(safe_divide(conversions_value, spend), 2) AS roas
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__url_report`
),
bing_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        keyword_id,
        keyword_name,
        CAST(
            NULL AS STRING
        ) AS final_url,
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
        ROUND(safe_divide(conversions_value, spend), 2) AS roas
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__keyword_report`
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
    bing_stats
    );
  