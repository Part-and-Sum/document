
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account_stats`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        *
    FROM
        `secure-electron-279822.google_ads_2025.ads_AccountBasicStats_8196795413`
),
blue_vine AS (
    SELECT
        *
    FROM
        `secure-electron-279822.google_bluevine.ads_AccountBasicStats_2828502255`
)
SELECT
    customer_id,
    metrics_clicks,
    metrics_conversions,
    metrics_conversions_value,
    metrics_cost_micros,
    metrics_impressions,
    metrics_interaction_event_types,
    metrics_interactions,
    metrics_view_through_conversions,
    segments_ad_network_type,
    segments_date,
    segments_device,
    segments_slot,
    _LATEST_DATE,
    _DATA_DATE
FROM
    base
UNION ALL
SELECT
    customer_id,
    metrics_clicks,
    metrics_conversions,
    metrics_conversions_value,
    metrics_cost_micros,
    metrics_impressions,
    metrics_interaction_event_types,
    metrics_interactions,
    metrics_view_through_conversions,
    segments_ad_network_type,
    segments_date,
    segments_device,
    segments_slot,
    _LATEST_DATE,
    _DATA_DATE
FROM
    blue_vine
    );
  