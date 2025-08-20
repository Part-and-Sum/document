
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_search_term_stats`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        ad_group_ad_ad_id,
        ad_group_id,
        campaign_id,
        customer_id,
        metrics_absolute_top_impression_percentage,
        metrics_all_conversions,
        metrics_all_conversions_from_interactions_rate,
        metrics_all_conversions_value,
        metrics_average_cost,
        metrics_average_cpc,
        metrics_average_cpe,
        metrics_average_cpm,
        metrics_average_cpv,
        metrics_clicks,
        metrics_conversions,
        metrics_conversions_from_interactions_rate,
        metrics_conversions_value,
        metrics_cost_micros,
        metrics_cost_per_all_conversions,
        metrics_cost_per_conversion,
        metrics_cross_device_conversions,
        metrics_ctr,
        metrics_engagement_rate,
        metrics_engagements,
        metrics_impressions,
        metrics_interaction_event_types,
        metrics_interaction_rate,
        metrics_interactions,
        metrics_top_impression_percentage,
        metrics_value_per_all_conversions,
        metrics_value_per_conversion,
        metrics_video_quartile_p100_rate,
        metrics_video_quartile_p25_rate,
        metrics_video_quartile_p50_rate,
        metrics_video_quartile_p75_rate,
        metrics_video_view_rate,
        metrics_video_views,
        metrics_view_through_conversions,
        search_term_view_search_term,
        search_term_view_status,
        segments_ad_network_type,
        segments_date,
        segments_day_of_week,
        segments_device,
        segments_keyword_ad_group_criterion,
        segments_month,
        segments_quarter,
        segments_search_term_match_type,
        segments_week,
        segments_year,
        _LATEST_DATE,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_SearchQueryStats_8196795413`
),
blue_vine AS (
    SELECT
        ad_group_ad_ad_id,
        ad_group_id,
        campaign_id,
        customer_id,
        metrics_absolute_top_impression_percentage,
        metrics_all_conversions,
        metrics_all_conversions_from_interactions_rate,
        metrics_all_conversions_value,
        metrics_average_cost,
        metrics_average_cpc,
        metrics_average_cpe,
        metrics_average_cpm,
        metrics_average_cpv,
        metrics_clicks,
        metrics_conversions,
        metrics_conversions_from_interactions_rate,
        metrics_conversions_value,
        metrics_cost_micros,
        metrics_cost_per_all_conversions,
        metrics_cost_per_conversion,
        metrics_cross_device_conversions,
        metrics_ctr,
        metrics_engagement_rate,
        metrics_engagements,
        metrics_impressions,
        metrics_interaction_event_types,
        metrics_interaction_rate,
        metrics_interactions,
        metrics_top_impression_percentage,
        metrics_value_per_all_conversions,
        metrics_value_per_conversion,
        metrics_video_quartile_p100_rate,
        metrics_video_quartile_p25_rate,
        metrics_video_quartile_p50_rate,
        metrics_video_quartile_p75_rate,
        metrics_video_view_rate,
        metrics_video_views,
        metrics_view_through_conversions,
        search_term_view_search_term,
        search_term_view_status,
        segments_ad_network_type,
        segments_date,
        segments_day_of_week,
        segments_device,
        segments_keyword_ad_group_criterion,
        segments_month,
        segments_quarter,
        segments_search_term_match_type,
        segments_week,
        segments_year,
        _LATEST_DATE,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_bluevine.ads_SearchQueryStats_2828502255`
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
  