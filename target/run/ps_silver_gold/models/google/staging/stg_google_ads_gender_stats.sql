
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_gender_stats`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        ad_group_criterion_criterion_id,
        ad_group_id,
        campaign_id,
        customer_id,
        ad_group_base_ad_group,
        campaign_base_campaign,
        metrics_active_view_cpm,
        metrics_active_view_ctr,
        metrics_active_view_impressions,
        metrics_active_view_measurability,
        metrics_active_view_measurable_cost_micros,
        metrics_active_view_measurable_impressions,
        metrics_active_view_viewability,
        metrics_all_conversions,
        metrics_all_conversions_from_interactions_rate,
        metrics_all_conversions_value,
        metrics_average_cost,
        metrics_average_cpc,
        metrics_average_cpm,
        metrics_clicks,
        metrics_conversions,
        metrics_conversions_from_interactions_rate,
        metrics_conversions_value,
        metrics_cost_micros,
        metrics_cost_per_all_conversions,
        metrics_cost_per_conversion,
        metrics_cross_device_conversions,
        metrics_ctr,
        metrics_gmail_forwards,
        metrics_gmail_saves,
        metrics_gmail_secondary_clicks,
        metrics_impressions,
        metrics_interaction_event_types,
        metrics_interaction_rate,
        metrics_interactions,
        metrics_value_per_all_conversions,
        metrics_value_per_conversion,
        segments_ad_network_type,
        segments_click_type,
        segments_date,
        segments_day_of_week,
        segments_device,
        segments_month,
        segments_quarter,
        segments_week,
        segments_year,
        _LATEST_DATE,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_GenderStats_8196795413`
),
blue_vine AS (
    SELECT
        ad_group_criterion_criterion_id,
        ad_group_id,
        campaign_id,
        customer_id,
        ad_group_base_ad_group,
        campaign_base_campaign,
        metrics_active_view_cpm,
        metrics_active_view_ctr,
        metrics_active_view_impressions,
        metrics_active_view_measurability,
        metrics_active_view_measurable_cost_micros,
        metrics_active_view_measurable_impressions,
        metrics_active_view_viewability,
        metrics_all_conversions,
        metrics_all_conversions_from_interactions_rate,
        metrics_all_conversions_value,
        metrics_average_cost,
        metrics_average_cpc,
        metrics_average_cpm,
        metrics_clicks,
        metrics_conversions,
        metrics_conversions_from_interactions_rate,
        metrics_conversions_value,
        metrics_cost_micros,
        metrics_cost_per_all_conversions,
        metrics_cost_per_conversion,
        metrics_cross_device_conversions,
        metrics_ctr,
        metrics_gmail_forwards,
        metrics_gmail_saves,
        metrics_gmail_secondary_clicks,
        metrics_impressions,
        metrics_interaction_event_types,
        metrics_interaction_rate,
        metrics_interactions,
        metrics_value_per_all_conversions,
        metrics_value_per_conversion,
        segments_ad_network_type,
        segments_click_type,
        segments_date,
        segments_day_of_week,
        segments_device,
        segments_month,
        segments_quarter,
        segments_week,
        segments_year,
        _LATEST_DATE,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_bluevine.ads_GenderStats_2828502255`
)
SELECT
    *
FROM
    base
UNION ALL
SELECT
    *
FROM
    blue_vine
    );
  