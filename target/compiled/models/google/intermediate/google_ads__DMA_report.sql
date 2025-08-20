

with stats as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_geo_stats`
), 

campaigns as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_campaign`
),

accounts as (
    select * from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_account`
),

geo as (
    select * 
    from `secure-electron-279822.fact_lookups.google_geotarget`
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
        stats.segments_geo_target_most_specific_location as criteria_id,
        geo.name as geo_name,
        geo.canonical_name as geo_target,
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
    left join geo
        on cast(regexp_extract(stats.segments_geo_target_most_specific_location, r'geoTargetConstants/(\d+)') as int64) = geo.criteria_id
    left join campaigns
        on stats.campaign_id = campaigns.campaign_id
    left join accounts
        on stats.customer_id = accounts.customer_id
    left join mapping on CAST(mapping.account_id AS INT64) = stats.customer_id
    group by 
        Date,  
        accounts.account_name,
        accounts.customer_id,       
        campaigns.campaign_name,
        stats.campaign_id,
        stats.segments_geo_target_most_specific_location,
        geo.name,
        geo.canonical_name,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)

select *
from fields