with base as (

    select * 
    from `secure-electron-279822.bing_ads.keyword_performance_daily_report`

),

fields as (

    select
        account_id,
        ad_distribution,
        ad_group_id,
        ad_id,
        bid_match_type,
        campaign_id,
        clicks,
        currency_code,
        date,
        delivered_match_type,
        device_os,
        device_type,
        impressions,
        keyword_id,
        language,
        network,
        spend,
        top_vs_other,
        conversions_qualified,
        conversions,
        revenue,
        all_conversions,
        all_conversions_qualified,
        all_revenue,
        cast('' as STRING) as source_relation
    from base
),

final as (

    select
        source_relation, 
        date as date_day,
        account_id,
        campaign_id,
        ad_group_id,
        ad_id,
        keyword_id,
        currency_code,
        device_os,
        device_type,
        network,
        language,
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as int64), cast(conversions as int64)), 0) as conversions,
        coalesce(cast(revenue as float64), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as int64), cast(all_conversions as int64)), 0) as all_conversions,
        coalesce(cast(replace(cast(all_revenue as STRING), ',', '') as float64), 0) as all_conversions_value
    from fields
)

select * 
from final