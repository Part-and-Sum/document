with base as (
    select * 
    from `secure-electron-279822.bing_ads.search_query_performance_daily_report`
),

fields as (
    select
        account_id,
        ad_group_id,
        ad_id,
        bid_match_type,
        campaign_id,
        clicks,
        date,
        delivered_match_type,
        device_os,
        device_type,
        impressions,
        keyword_id,
        language,
        network,
        search_query,
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
        search_query,
        device_os,
        device_type,
        network,
        language,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as INT64), cast(conversions as INT64)), 0) as conversions,
        coalesce(cast(revenue as FLOAT64), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as INT64), cast(all_conversions as INT64)), 0) as all_conversions,
        coalesce(cast(replace(cast(all_revenue as STRING), ',', '') as FLOAT64), 0) as all_conversions_value
    from fields
)

select * 
from final