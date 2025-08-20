with base as (

    select * 
    from `secure-electron-279822.bing_ads.campaign_performance_daily_report`

),

fields as (

    select
        account_id as account_id,
        ad_distribution as ad_distribution,
        bid_match_type as bid_match_type,
        campaign_id as campaign_id,
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
        budget_association_status as budget_association_status,
        budget_name as budget_name,
        cast(null as STRING) as budget_status,
        conversions_qualified as conversions_qualified,
        conversions as conversions,
        revenue as revenue,
        all_conversions as all_conversions,
        all_conversions_qualified as all_conversions_qualified,
        all_revenue as all_revenue,
        cast('' as STRING) as source_relation
    from base
),

final as (

    select
        source_relation, 
        date as date_day,
        account_id,
        campaign_id,
        currency_code,
        device_os,
        device_type,
        network,
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        budget_association_status,
        budget_name,
        budget_status,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as int64), cast(conversions as int64)), 0) as conversions,
        coalesce(cast(revenue as float64), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as int64), cast(all_conversions as int64)), 0) as all_conversions,
        -- sometimes this field comes in as a string
        coalesce(cast(replace(cast(all_revenue as STRING), ',', '') as float64), 0) as all_conversions_value
    from fields
)

select * 
from final