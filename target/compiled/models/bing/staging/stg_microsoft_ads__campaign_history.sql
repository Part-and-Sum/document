with base as (

    select * 
    from `secure-electron-279822.bing_ads.campaign_history`

),

fields as (

    select
        id as id, 
        name as name, 
        account_id as account_id, 
        modified_time as modified_time, 
        type as type, 
        time_zone as time_zone, 
        status as status, 
        budget as budget, 
        budget_id as budget_id, 
        budget_type as budget_type, 
        language as language,
        cast('' as STRING) as source_relation
    from base
),

final as (

    select
        source_relation, 
        id as campaign_id,
        name as campaign_name,
        account_id,
        modified_time as modified_at,
        type,
        time_zone,
        status,
        budget,
        budget_id,
        budget_type,
        language,
        row_number() over (
            partition by source_relation, id 
            order by modified_time desc
        ) = 1 as is_most_recent_record
    from fields
)

select * 
from final