

with stats as (
    select * from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_keyword_stats`
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

keywords as (
    select *
    from `ps-silver-gold`.`staging_google_ads`.`stg_google_ads_keyword`
),

mapping as (
    select * from `ps-silver-gold.mapping.mapping`
),

fields as (

    select
        stats.segments_date as Date,
        keywords.ad_group_criterion_criterion_id as keyword_id,
        keywords.ad_group_criterion_keyword_text as keyword_text,
        accounts.customer_id as account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        keywords.ad_group_criterion_keyword_match_type as keyword_type,
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
    left join keywords
        on stats.ad_group_criterion_criterion_id = keywords.ad_group_criterion_criterion_id
    left join ad_groups
        on stats.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.customer_id = accounts.customer_id
    left join mapping on CAST(mapping.account_id AS INT64) = campaigns.customer_id
    group by 
        Date,
        keywords.ad_group_criterion_criterion_id,
        keywords.ad_group_criterion_keyword_text,
        accounts.customer_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        keywords.ad_group_criterion_keyword_match_type,
        mapping.client_id, 
        mapping.client_name, 
        mapping.sub_client_name, 
        mapping.ad_platform
)

select *
from fields