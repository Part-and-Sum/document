

with stats as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_ad_stats`
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

ads as (
    select distinct ad_group_ad_ad_id, ad_group_ad_ad_type, ad_group_ad_ad_final_urls, ad_group_ad_ad_expanded_text_ad_description
    from `secure-electron-279822.google_ads_2025.ads_Ad_8196795413`
),

video as (
    select
        ad_group_ad_ad_id,
        segments_date,
        sum(metrics_video_views) as video_views,
        sum(metrics_engagements) as engagements
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_video_stats`
    group by ad_group_ad_ad_id, segments_date
),

mapping as (
    select * from `ps-silver-gold.mapping.mapping`
),

fields as (

    select
        stats.segments_date as Date,
        ads.ad_group_ad_ad_id as ad_id,
        ads.ad_group_ad_ad_expanded_text_ad_description as ad_description,
        accounts.customer_id as account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ads.ad_group_ad_ad_type as ad_type,
        ads.ad_group_ad_ad_final_urls as final_urls,
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
    left join ads on stats.ad_group_ad_ad_id = ads.ad_group_ad_ad_id
    left join ad_groups on stats.ad_group_id = ad_groups.ad_group_id
    left join campaigns on ad_groups.campaign_id = campaigns.campaign_id
    left join accounts on campaigns.customer_id = accounts.customer_id
    left join video on stats.ad_group_ad_ad_id = video.ad_group_ad_ad_id and stats.segments_date = video.segments_date
    left join mapping on CAST(mapping.account_id AS INT64) = campaigns.customer_id
    group by
        Date,
        ads.ad_group_ad_ad_id,
        ads.ad_group_ad_ad_expanded_text_ad_description,
        accounts.customer_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ads.ad_group_ad_ad_type,
        ads.ad_group_ad_ad_final_urls,
        video.video_views,
        video.engagements,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)

select *
from fields