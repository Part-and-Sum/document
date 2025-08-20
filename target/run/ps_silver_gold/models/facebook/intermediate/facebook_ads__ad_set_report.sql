
  
    

    create or replace table `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__ad_set_report`
      
    
    

    OPTIONS()
    as (
      WITH report AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__basic_ad`
), 

conversion_report AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`int_facebook_ads__conversions`
), 

accounts AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__account_history`
    WHERE is_most_recent_record = TRUE
),

campaigns AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__campaign_history`
    WHERE is_most_recent_record = TRUE
),

ad_sets AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__ad_set_history`
    WHERE is_most_recent_record = TRUE
),

ads AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__ad_history`
    WHERE is_most_recent_record = TRUE
),

mapping AS (
    SELECT *
    FROM `ps-silver-gold.mapping.mapping`
    WHERE ad_platform = 'meta'
),

joined AS (
    SELECT 
        report.date_day,
        report.account_id,
        mapping.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_sets.ad_set_id,
        ad_sets.ad_set_name,
        ads.ad_id,
        ads.ad_name,
        ads.conversion_domain,

        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,

        SUM(report.clicks) AS clicks,
        SUM(report.impressions) AS impressions,
        SUM(report.spend) AS spend,
        SUM(COALESCE(conversion_report.conversions, 0)) AS conversions,
        SUM(COALESCE(conversion_report.conversions_value, 0)) AS conversions_value

    FROM report 
    LEFT JOIN conversion_report
        ON report.date_day = conversion_report.date_day
        AND report.ad_id = conversion_report.ad_id
        AND report.source_relation = conversion_report.source_relation
    LEFT JOIN ads 
        ON report.ad_id = ads.ad_id
        AND report.source_relation = ads.source_relation
    LEFT JOIN campaigns
        ON ads.campaign_id = campaigns.campaign_id
        AND ads.source_relation = campaigns.source_relation
    LEFT JOIN ad_sets
        ON ads.ad_set_id = ad_sets.ad_set_id
        AND ads.source_relation = ad_sets.source_relation
    LEFT JOIN mapping
        ON CAST(report.account_id AS STRING) = CAST(mapping.account_id AS STRING)
    GROUP BY ALL
)

SELECT *
FROM joined
    );
  