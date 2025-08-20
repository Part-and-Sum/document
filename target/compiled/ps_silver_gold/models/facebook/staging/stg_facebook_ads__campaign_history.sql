with base as (

    select * 
    from `secure-electron-279822.facebook_ads.campaign_history`

),

fields as (

    select
        updated_time as updated_time, 
        cast(null as timestamp) as created_time, 
        account_id as account_id, 
        id as id, 
        name as name, 
        cast(null as timestamp) as start_time, 
        cast(null as timestamp) as stop_time, 
        cast(null as string) as status, 
        cast(null as INT64) as daily_budget, 
        cast(null as INT64) as lifetime_budget, 
        cast(null as FLOAT64) as budget_remaining,
        cast('' as string) as source_relation
    from base

),

final as (

    select
        source_relation, 
        updated_time as updated_at,
        created_time as created_at,
        cast(account_id as bigint) as account_id,
        cast(id as bigint) as campaign_id,
        name as campaign_name,
        start_time as start_at,
        stop_time as end_at,
        status,
        daily_budget,
        lifetime_budget,
        budget_remaining,
        case 
            when id is null and updated_time is null 
                then row_number() over (partition by source_relation order by source_relation)
            else 
                row_number() over (partition by source_relation, id order by updated_time desc) 
        end = 1 as is_most_recent_record
    from fields

)

select * 
from final