with base as (

    select * 
    from `secure-electron-279822.facebook_ads.demographics_country`

),

fields as (

    select
        _fivetran_id as _fivetran_id,
        _fivetran_synced as _fivetran_synced,
        account_id as account_id,
        country as country,
        date as date,
        frequency as frequency,
        impressions as impressions,
        inline_link_clicks as inline_link_clicks,
        reach as reach,
        spend as spend,
        cast('' as string) as source_relation
    from base

),

final as (

    select 
        source_relation, 
        _fivetran_id as country_id,
        country,
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