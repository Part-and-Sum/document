with base as (
    select * 
    from `secure-electron-279822.pinterest_ads.advertiser_history`
),

final as (
    select
        cast('' as STRING) as source_relation,
        cast(id as STRING) as advertiser_id,
        name as advertiser_name,
        country,
        created_time as created_at,
        currency as currency_code,
        owner_user_id,
        owner_username,
        account_permissions as advertiser_permissions,
        updated_time as updated_at,
        row_number() over (partition by cast('' as STRING), id order by updated_time desc) = 1 as is_most_recent_record
    from base
)

select *
from final