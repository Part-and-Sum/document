

with stats as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_campaign_stats`
), 


campaigns as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_PMAX`
    where campaign_advertising_channel_type = 'PERFORMANCE_MAX'
), 

accounts as (
    select * from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_account`
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
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
    from stats
    join campaigns on stats.campaign_id = campaigns.campaign_id
    left join accounts on campaigns.customer_id = accounts.customer_id
    left join mapping on CAST(mapping.account_id AS INT64) = campaigns.customer_id
    
    group by
        Date,  
        accounts.account_name,
        accounts.customer_id,       
        campaigns.campaign_name,
        campaigns.campaign_id,
        campaigns.campaign_advertising_channel_type,
        campaigns.campaign_status,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)

select *
from fields