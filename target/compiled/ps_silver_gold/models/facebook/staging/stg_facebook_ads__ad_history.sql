with base as (

    select * 
    from `secure-electron-279822.facebook_ads.ad_history`

),

fields as (

    select
        updated_time as updated_time, 
        id as id, 
        name as name, 
        account_id as account_id, 
        ad_set_id as ad_set_id, 
        campaign_id as campaign_id, 
        creative_id as creative_id, 
        cast(null as string) as conversion_domain,
        cast('' as string) as source_relation
    from base

),

final as (

    select
        source_relation, 
        updated_time as updated_at,
        cast(id as bigint) as ad_id,
        name as ad_name,
        cast(account_id as bigint) as account_id,
        cast(ad_set_id as bigint) as ad_set_id,   
        cast(campaign_id as bigint) as campaign_id,
        cast(creative_id as bigint) as creative_id,
        conversion_domain,
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