with base as (

    select * 
    from `secure-electron-279822.facebook_ads.basic_ad`

),

fields as (

    select
        ad_id as ad_id, 
        cast(null as string) as ad_name, 
        cast(null as string) as adset_name, 
        date as date, 
        account_id as account_id, 
        impressions as impressions, 
        inline_link_clicks as inline_link_clicks, 
        spend as spend, 
        reach as reach, 
        cast(null as FLOAT64) as frequency,
        cast('' as string) as source_relation
    from base

),

final as (

    select
        source_relation, 
        cast(ad_id as bigint) as ad_id,
        ad_name,
        adset_name as ad_set_name,
        date as date_day,
        cast(account_id as bigint) as account_id,
        impressions,
        coalesce(inline_link_clicks, 0) as clicks,
        spend,
        reach,
        frequency
    from fields

)

select * 
from final