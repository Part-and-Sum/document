with base as (

    select * 
    from `secure-electron-279822.bing_ads.geographic_performance_daily_report`

),

fields as (

    select
        account_id,
        ad_distribution,
        ad_group_id,
        all_conversions,
        all_conversions_qualified,
        all_revenue,
        bid_match_type,
        campaign_id,
        city,
        clicks,
        conversions,
        conversions_qualified,
        country,
        county,
        currency_code,
        date,
        delivered_match_type,
        device_os,
        device_type,
        goal,
        impressions,
        language,
        location_id,
        location_type,
        metro_area,
        cast(null as STRING) as most_specific_location,
        network,
        postal_code,
        spend,
        state,
        top_vs_other,
        revenue,
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
        country,
        state as region,
        county,
        postal_code,
        city,
        metro_area,
        location_id,
        location_type,
        most_specific_location,
        currency_code,
        device_os,
        device_type,
        network,
        language,
        ad_distribution,
        bid_match_type,
        delivered_match_type,
        top_vs_other,
        goal,
        coalesce(clicks, 0) as clicks, 
        coalesce(impressions, 0) as impressions,
        coalesce(spend, 0) as spend,
        coalesce(coalesce(cast(conversions_qualified as int64), cast(conversions as int64)), 0) as conversions,
        coalesce(cast(revenue as float64), 0) as conversions_value,
        coalesce(coalesce(cast(all_conversions_qualified as int64), cast(all_conversions as int64)), 0) as all_conversions,
        coalesce(cast(replace(cast(all_revenue as string), ',', '') as float64), 0) as all_conversions_value
    from fields
)

select *
from final