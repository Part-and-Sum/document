with base as (

    select * 
    from `secure-electron-279822.facebook_ads.ad_set_history`

),

fields as (

    select
        updated_time as updated_time, 
        id as id, 
        name as name, 
        account_id as account_id, 
        campaign_id as campaign_id, 
        cast(null as timestamp) as start_time, 
        cast(null as timestamp) as end_time, 
        cast(null as string) as bid_strategy, 
        cast(null as int64) as daily_budget, 
        cast(null as int64) as budget_remaining, 
        cast(null as string) as status, 
        cast(null as string) as optimization_goal,
        cast('' as string) as source_relation
    from base

),

final as (

    select
        source_relation, 
        updated_time as updated_at,
        cast(id as bigint) as ad_set_id,
        name as ad_set_name,
        cast(account_id as bigint) as account_id,
        cast(campaign_id as bigint) as campaign_id,
        start_time as start_at,
        end_time as end_at,
        bid_strategy,
        daily_budget,
        budget_remaining,
        status,
        optimization_goal,
        case 
            when id is null and updated_time is null then 
                row_number() over (partition by source_relation order by source_relation)
            else 
                row_number() over (partition by source_relation, id order by updated_time desc) 
        end = 1 as is_most_recent_record
    from fields

)

select * 
from final