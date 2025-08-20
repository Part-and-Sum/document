with base as (

    select * 
    from `secure-electron-279822.facebook_ads.account_history`

),

fields as (

    select
        id as id,
        _fivetran_synced as _fivetran_synced,
        name as name,
        cast(null as string) as account_status,
        cast(null as string) as business_country_code,
        cast(null as timestamp) as created_time,
        cast(null as string) as currency,
        cast(null as string) as timezone_name,
        cast(null as float64) as timezone_offset_hours_utc,
        cast(null as string) as business_state,
        cast(null as int64) as min_daily_budget,
        cast('' as string) as source_relation
    from base

),

final as (

    select
        source_relation, 
        cast(id as bigint) as account_id,
        _fivetran_synced,
        name as account_name,
        account_status,
        business_country_code,
        business_state,
        created_time as created_at,
        currency,
        timezone_name,
        timezone_offset_hours_utc,
        min_daily_budget,
        case 
            when id is null and _fivetran_synced is null then 
                row_number() over (partition by source_relation order by source_relation)
            else 
                row_number() over (partition by source_relation, id order by _fivetran_synced desc) 
        end = 1 as is_most_recent_record
    from fields

)

select * 
from final