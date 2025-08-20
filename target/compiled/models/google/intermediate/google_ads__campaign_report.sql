

with stats as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_campaign_stats`
), 

campaigns as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_campaign`
), 

accounts as (
    select * from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_account`
),

video as (
    select
        campaign_id,
        segments_date,
        sum(metrics_video_views) as video_views,
        sum(metrics_engagements) as engagements
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_video_stats`
    group by campaign_id, segments_date
),

mapping as (
    select * from `ps-silver-gold.mapping.mapping`
),

fields as (

    select
        stats.segments_date as Date,
        accounts.customer_id as account_id,
        accounts.account_name,
        stats.campaign_id,
        campaigns.campaign_name,
        campaigns.campaign_advertising_channel_type,
        campaigns.campaign_status,
        round(sum(stats.metrics_cost_micros) / 1e6, 2) as spend_usd,
        sum(stats.metrics_clicks) as clicks,
        sum(stats.metrics_impressions) as impressions,
        sum(stats.metrics_conversions) as conversions,
        sum(stats.metrics_conversions_value) as conversions_value,
        round(safe_divide(sum(stats.metrics_clicks), sum(stats.metrics_impressions)) * 100, 2) as daily_CTR_percent,
        round(safe_divide(sum(stats.metrics_cost_micros) / 1e6, sum(stats.metrics_clicks)), 2) as daily_CPC_usd,
        round(safe_divide(sum(stats.metrics_cost_micros) / 1e6, sum(stats.metrics_impressions)) * 1000, 2) as daily_CPM_usd,
        round(safe_divide(sum(stats.metrics_cost_micros) / 1e6, sum(stats.metrics_conversions)), 2) as daily_CPA_usd,
        ROUND(SAFE_DIVIDE(SUM(stats.metrics_conversions_value), SUM(stats.metrics_cost_micros) / 1e6) * 100, 2) AS daily_ROAS_usd,
        video.video_views,
        video.engagements,      
        round(safe_divide(video.video_views, sum(metrics_impressions)) * 100, 2) as video_view_rate_percent,
        round(safe_divide(sum(metrics_cost_micros) / 1e6, video.video_views), 2) as daily_CPV_usd,
        round(safe_divide(video.engagements, sum(metrics_impressions)) * 100, 2) as daily_CPE_usd,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform

    from stats
    left join campaigns on stats.campaign_id = campaigns.campaign_id
    left join accounts on campaigns.customer_id = accounts.customer_id
    left join video on stats.campaign_id = video.campaign_id and stats.segments_date = video.segments_date
    left join mapping on CAST(mapping.account_id AS INT64) = campaigns.customer_id
    group by
        Date,  
        accounts.account_name,
        accounts.customer_id,       
        campaigns.campaign_name,
        stats.campaign_id,
        campaigns.campaign_advertising_channel_type,
        campaigns.campaign_status,
        video.video_views,
        video.engagements,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)

select *
from fields
where campaign_status = 'ENABLED'