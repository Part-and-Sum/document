with hourly as (
    select *
    from `ps-silver-gold`.`staging_tiktok_ads_dev`.`stg_tiktok_ads__campaign_report_hourly`
), 

campaigns as (
    select *
    from `ps-silver-gold`.`staging_tiktok_ads_dev`.`stg_tiktok_ads__campaign_history`
    where is_most_recent_record = true
), 

advertiser as (
    select *
    from `ps-silver-gold`.`staging_tiktok_ads_dev`.`stg_tiktok_ads__advertiser`
),

mapping as (
    select *
    from `ps-silver-gold.mapping.mapping`
    where ad_platform = 'tiktok'
), 

aggregated as (
    select
        cast(hourly.stat_time_hour as date) as date_day,
        advertiser.advertiser_id,
        advertiser.advertiser_name,
        hourly.campaign_id,
        campaigns.campaign_name,
        advertiser.currency,
        mapping.client_id,
        mapping.client_name,
        mapping.ad_platform,
        mapping.sub_client_name,
        sum(hourly.impressions) as impressions,
        sum(hourly.clicks) as clicks,
        sum(hourly.spend) as spend,
        sum(hourly.reach) as reach,
        sum(hourly.conversion) as conversion,
        sum(hourly.likes) as likes,
        sum(hourly.comments) as comments,
        sum(hourly.shares) as shares,
        sum(hourly.profile_visits) as profile_visits,
        sum(hourly.follows) as follows,
        sum(hourly.video_watched_2_s) as video_watched_2_s,
        sum(hourly.video_watched_6_s) as video_watched_6_s,
        sum(hourly.video_views_p_25) as video_views_p_25,
        sum(hourly.video_views_p_50) as video_views_p_50, 
        sum(hourly.video_views_p_75) as video_views_p_75,
        sum(hourly.spend) / nullif(sum(hourly.clicks), 0) as daily_cpc,
        (sum(hourly.spend) / nullif(sum(hourly.impressions), 0)) * 1000 as daily_cpm,
        (sum(hourly.clicks) / nullif(sum(hourly.impressions), 0)) * 100 as daily_ctr
    from hourly
    left join campaigns
        on hourly.campaign_id = campaigns.campaign_id
    left join advertiser
        on campaigns.advertiser_id = advertiser.advertiser_id
    left join mapping
        on cast(advertiser.advertiser_id as string) = cast(mapping.account_id as string)
    group by all
)

select *
from aggregated