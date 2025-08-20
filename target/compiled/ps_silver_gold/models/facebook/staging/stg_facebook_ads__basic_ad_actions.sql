with base as (

    select * 
    from `secure-electron-279822.facebook_ads.basic_ad_actions`

),

fields as (

    select
        _fivetran_id as _fivetran_id, 
        _fivetran_synced as _fivetran_synced, 
        action_type as action_type, 
        ad_id as ad_id, 
        date as date, 
        index as index, 
        value as value,
        cast('' as string) as source_relation
    from base

),

final as (
    
    select 
        source_relation, 
        lower(action_type) as action_type,
        cast(ad_id as bigint) as ad_id,
        date as date_day,
        cast(coalesce(value, 0) as FLOAT64) as conversions
    from fields

)

select *
from final