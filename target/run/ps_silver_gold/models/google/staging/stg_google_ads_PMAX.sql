
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_PMAX`
      
    
    

    OPTIONS()
    as (
      WITH all_pmax_campaign_history AS (
    SELECT
        campaign_id,
        campaign_name,
        campaign_advertising_channel_type,
        campaign_status,
        customer_id,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_Campaign_8196795413`
    WHERE
        campaign_advertising_channel_type = 'PERFORMANCE_MAX'
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
    WHERE
        campaign_advertising_channel_type = 'PERFORMANCE_MAX'
),
ranked_pmax_campaigns AS (
    SELECT
        campaign_id,
        campaign_name,
        campaign_advertising_channel_type,
        campaign_status,
        customer_id,
        _DATA_DATE,
        ROW_NUMBER() over(
            PARTITION BY campaign_id,
            customer_id
            ORDER BY
                _DATA_DATE DESC
        ) AS rn
    FROM
        all_pmax_campaign_history
)
SELECT
    campaign_id,
    campaign_name,
    campaign_advertising_channel_type,
    campaign_status,
    customer_id
FROM
    ranked_pmax_campaigns
WHERE
    rn = 1
    );
  