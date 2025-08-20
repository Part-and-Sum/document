with base as (

    select * 
    from `secure-electron-279822.facebook_ads.demographics_country_actions`

),

fields as (

    select
        _fivetran_id,
        _fivetran_synced,
        account_id,
        action_type,
        date,
        index,
        value,
        cast('' as string) as source_relation
    from base

),

final as (
    
    select 
        source_relation, 
        _fivetran_id as country_id,
        lower(action_type) as action_type,
        cast(account_id as bigint) as account_id,
        date as date_day,
        cast(coalesce(value, 0) as FLOAT64) as conversions
    from fields
)

select *
from final