
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_group`
      
    
    

    OPTIONS()
    as (
      WITH all_ad_group_history AS (
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id, -- Directly selecting customer_id as it exists in the source table
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_AdGroup_8196795413`
    UNION ALL
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id, -- Directly selecting customer_id as it exists in the source table
        _DATA_DATE
    FROM
        `secure-electron-279822.google_bluevine.ads_AdGroup_2828502255`
),
ranked_ad_groups AS (
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id, -- Include customer_id in the select for partitioning
        _DATA_DATE,
        -- Partition by ad_group_id, campaign_id AND customer_id for full uniqueness
        ROW_NUMBER() OVER(PARTITION BY ad_group_id, campaign_id, customer_id ORDER BY _DATA_DATE DESC) AS rn
    FROM
        all_ad_group_history
)
SELECT
    ad_group_id,
    ad_group_name,
    ad_group_status,
    ad_group_type,
    campaign_id,
    customer_id
    -- Do NOT include _DATA_DATE here if you want a single "latest" row per ad group
FROM
    ranked_ad_groups
WHERE
    rn = 1
    );
  