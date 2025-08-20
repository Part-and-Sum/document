

with stats as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_ad_group_stats`
),

accounts as (
    select * from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_account`
),

campaigns as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_campaign`
),

ad_groups as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_ad_group`
),

video as (
    SELECT
        ad_group_id,
        segments_date,
        SUM(metrics_video_views) AS video_views,
        sum(metrics_engagements) as engagements
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_video_stats`
    GROUP BY ad_group_id, segments_date
),

mapping as (
    select * from `ps-silver-gold.mapping.mapping`
),

fields as (
    select
        stats.segments_date as Date,
        accounts.customer_id as account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
        round(sum(stats.metrics_cost_micros) / 1e6, 2) as spend_usd,
        sum(stats.metrics_clicks) as clicks,
        sum(stats.metrics_impressions) as impressions,
        sum(stats.metrics_conversions) as conversions,
        sum(stats.metrics_conversions_value) as conversions_value,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_clicks), SUM(stats.metrics_impressions)) * 100, 2) AS daily_CTR_percent,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_clicks)), 2) AS daily_CPC_usd,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_impressions)) * 1000, 2) AS daily_CPM_usd,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_conversions)), 2) AS daily_CPA_usd,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_conversions_value), SUM(stats.metrics_cost_micros) / 1e6) * 100, 2) AS daily_ROAS_usd,
        video.video_views,
        video.engagements,
        ROUND(SAFE_DIVIDE(video.video_views, SUM(stats.metrics_impressions)) * 100, 2) AS video_view_rate_percent,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_cost_micros) / 1e6, video.video_views), 2) AS daily_CPV_usd,
        ROUND(SAFE_DIVIDE(video.engagements, SUM(stats.metrics_impressions)) * 100, 2) AS daily_CPE_usd,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
    from stats
    left join ad_groups
        on stats.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.customer_id = accounts.customer_id
    left join video
        on stats.ad_group_id = video.ad_group_id and stats.segments_date = video.segments_date
    left join mapping on CAST(mapping.account_id AS INT64) = campaigns.customer_id
    group by Date,
        accounts.account_name,
        accounts.customer_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
        video.video_views,
        video.engagements,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)


SELECT
  Date,
  account_id,
  account_name,
  campaign_id,
  campaign_name,
  NULL AS ad_group_id,
  NULL AS ad_group_name,
  NULL AS ad_group_status,
  NULL AS ad_group_type,
  spend_usd,
  clicks,
  impressions,
  conversions,
  conversions_value,
  daily_CTR_percent,
  daily_CPC_usd,
  daily_CPM_usd,
  daily_CPA_usd,
  daily_ROAS_usd,
  NULL AS video_views,
  NULL AS engagements,
  NULL AS video_view_rate_percent,
  NULL AS daily_CPV_usd,
  NULL AS daily_CPE_usd,
  client_id, 
  client_name, 
  sub_client_name, 
  ad_platform
FROM `ps-silver-gold`.`silver_google_ads`.`google_ads__PMAX_report`

UNION ALL

SELECT
  Date,
  account_id,
  account_name,
  campaign_id,
  campaign_name,
  ad_group_id,
  ad_group_name,
  ad_group_status,
  ad_group_type,
  spend_usd,
  clicks,
  impressions,
  conversions,
  conversions_value,
  daily_CTR_percent,
  daily_CPC_usd,
  daily_CPM_usd,
  daily_CPA_usd,
  daily_ROAS_usd,
  video_views,
  engagements,
  video_view_rate_percent,
  daily_CPV_usd,
  daily_CPE_usd,
  client_id, 
  client_name, 
  sub_client_name, 
  ad_platform
FROM fields