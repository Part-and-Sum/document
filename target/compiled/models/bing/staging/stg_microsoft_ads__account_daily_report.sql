with base as (

    select * 
    from `secure-electron-279822`.`bing_ads`.`account_performance_daily_report`

),

fields as (

    select
        account_id as account_id, 
        ad_distribution as ad_distribution, 
        bid_match_type as bid_match_type, 
        clicks as clicks, 
        currency_code as currency_code, 
        date as date, 
        delivered_match_type as delivered_match_type, 
        device_os as device_os, 
        device_type as device_type, 
        impressions as impressions, 
        network as network, 
        spend as spend, 
        top_vs_other as top_vs_other, 
        conversions_qualified as conversions_qualified, 
        conversions as conversions, 
        revenue as revenue, 
        all_conversions_qualified as all_conversions_qualified,
        cast('' as STRING) as source_relation
    from base

),

final as (

    select
        source_relation, 
        date as date_day,
        account_id,
        device_os,
        device_type,
        network,
        currency_code, 
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as integer), cast(conversions as integer)), 0) as conversions,
        coalesce(cast(revenue as float64), 0) as conversions_value,
        coalesce(cast(all_conversions_qualified as integer), 0) as all_conversions

    from fields
)

select * 
from final