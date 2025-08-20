
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_campaign`
      
    
    

    OPTIONS()
    as (
      WITH all_campaign_history AS (
    SELECT
        campaign_id,
        campaign_name,
        campaign_advertising_channel_type,
        campaign_status,
        customer_id,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_Campaign_8196795413`
    UNION ALL
    SELECT
        campaign_id,
        campaign_name,
        campaign_advertising_channel_type,
        campaign_status,
        customer_id,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_bluevine.ads_Campaign_2828502255`
),
ranked_campaigns AS (
    SELECT
        campaign_id,
        campaign_name,
        campaign_advertising_channel_type,
        campaign_status,
        customer_id,
        _DATA_DATE,
        -- Partition by both campaign_id AND customer_id to get the latest per campaign within each account
        ROW_NUMBER() OVER(PARTITION BY campaign_id, customer_id ORDER BY _DATA_DATE DESC) AS rn
    FROM
        all_campaign_history
)
SELECT
    campaign_id,
    campaign_name,
    campaign_advertising_channel_type,
    campaign_status,
    customer_id
    -- Do NOT include _DATA_DATE here if you want a single "latest" row per campaign
FROM
    ranked_campaigns
WHERE
    rn = 1
    );
  