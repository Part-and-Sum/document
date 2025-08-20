with base as (

    select * 
    from `secure-electron-279822.bing_ads.account_history`

),

fields as (

    select
        id as id, 
        name as name, 
        last_modified_time as last_modified_time, 
        time_zone as time_zone, 
        currency_code as currency_code,
        cast('' as STRING) as source_relation
    from base

),

final as (

    select
        source_relation, 
        id as account_id,
        name as account_name,
        last_modified_time as modified_at,
        time_zone,
        currency_code,
        row_number() over (
            partition by source_relation, id 
            order by last_modified_time desc
        ) = 1 as is_most_recent_record
    from fields

)

select * 
from final