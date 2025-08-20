with base as (

    select * 
    from `secure-electron-279822.bing_ads.keyword_history`

),

fields as (

    select
        id,
        name,
        modified_time,
        ad_group_id,
        match_type,
        status,
        cast('' as STRING) as source_relation
    from base
),

final as (

    select
        source_relation, 
        id as keyword_id,
        name as keyword_name,
        modified_time as modified_at,
        ad_group_id,
        match_type,
        status,
        row_number() over (partition by source_relation, id order by modified_time desc) = 1 as is_most_recent_record
    from fields
)

select * 
from final