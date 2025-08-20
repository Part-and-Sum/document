
  
    

    create or replace table `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__ad_conversions_report`
      
    
    

    OPTIONS()
    as (
      WITH stats AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_conversion_stats`
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
ads AS (
    SELECT
        DISTINCT ad_group_ad_ad_id,
        ad_group_ad_ad_type,
        ad_group_ad_ad_final_urls,
        ad_group_ad_ad_name,
        ad_group_ad_ad_expanded_text_ad_description,
        ad_group_ad_status
    FROM
        (
            SELECT
                *
            FROM
                `secure-electron-279822.google_ads_2025.ads_Ad_8196795413`
            UNION ALL
            SELECT
                *
            FROM
                `secure-electron-279822.google_bluevine.ads_Ad_2828502255`
        )
    WHERE
        ad_group_ad_status = 'ENABLED'
        and _LATEST_DATE = _DATA_DATE
    GROUP BY
        ad_group_ad_ad_id,
        ad_group_ad_ad_type,
        ad_group_ad_ad_final_urls,
        ad_group_ad_ad_name,
        ad_group_ad_ad_expanded_text_ad_description,
        ad_group_ad_status
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
        ads.ad_group_ad_ad_id AS ad_id,
        ads.ad_group_ad_ad_name AS ad_name,
        ads.ad_group_ad_ad_expanded_text_ad_description AS ad_description,
        campaigns.customer_id AS account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ads.ad_group_ad_ad_type AS ad_type,
        ads.ad_group_ad_status AS ad_status,
        stats.segments_conversion_action_category AS action_category,
        stats.segments_conversion_action_name AS action_name,
        SUM(
            stats.metrics_conversions
        ) AS conversions,
        SUM(
            stats.metrics_conversions_value
        ) AS conversions_value,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
    FROM
        stats
        LEFT JOIN ads
        ON stats.ad_group_ad_ad_id = ads.ad_group_ad_ad_id
        LEFT JOIN ad_groups
        ON stats.ad_group_id = ad_groups.ad_group_id
        LEFT JOIN campaigns
        ON ad_groups.campaign_id = campaigns.campaign_id
        LEFT JOIN accounts
        ON campaigns.customer_id = accounts.customer_id
        LEFT JOIN mapping
        ON CAST(
            mapping.account_id AS STRING
        ) = CAST(
            campaigns.customer_id AS STRING
        )
    GROUP BY
        stats.segments_date,
        ads.ad_group_ad_ad_id,
        ads.ad_group_ad_ad_expanded_text_ad_description,
        campaigns.customer_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ads.ad_group_ad_ad_type,
        ads.ad_group_ad_ad_name,
        stats.segments_conversion_action_category,
        stats.segments_conversion_action_name,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        ads.ad_group_ad_status,
        mapping.ad_platform
)
SELECT
    *
FROM
    fields
    );
  