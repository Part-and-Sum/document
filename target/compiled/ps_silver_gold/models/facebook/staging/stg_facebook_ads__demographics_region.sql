with base as (

    select * 
    from `secure-electron-279822`.`raw_facebook_ads`.`demographics_region`

),

fields as (

    select
        _fivetran_id,
        _fivetran_synced,
        account_id,
        date,
        frequency,
        impressions,
        inline_link_clicks,
        reach,
        region,
        spend,
        cast('' as string) as source_relation
    from base

),

final as (
    
    select 
        source_relation, 
        _fivetran_id as region_id,
        region,
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