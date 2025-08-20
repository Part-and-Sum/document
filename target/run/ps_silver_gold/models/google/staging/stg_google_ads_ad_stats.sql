
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_stats`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        *
    FROM
        `secure-electron-279822.google_ads_2025.ads_AdBasicStats_8196795413`
),
blue_vine AS (
    SELECT
        *
    FROM
        `secure-electron-279822.google_bluevine.ads_AdBasicStats_2828502255`
)
SELECT
    ad_group_ad_ad_id,
    ad_group_id,
    customer_id,
    ad_group_ad_ad_group,
    ad_group_base_ad_group,
    campaign_base_campaign,
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
    ad_group_ad_ad_id,
    ad_group_id,
    customer_id,
    ad_group_ad_ad_group,
    ad_group_base_ad_group,
    campaign_base_campaign,
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
  