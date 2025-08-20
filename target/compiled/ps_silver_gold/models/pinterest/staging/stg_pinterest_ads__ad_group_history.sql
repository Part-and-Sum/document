with base as (
    select *
    from `secure-electron-279822.pinterest_ads.ad_group_history`
),

final as (
    select
        cast('' as string) as source_relation,
        cast(id as string) as ad_group_id,
        name as ad_group_name,
        status as ad_group_status,
        ad_account_id as advertiser_id,
        _fivetran_synced,
        cast(campaign_id as string) as campaign_id,
        created_time as created_at,
        end_time,
        pacing_delivery_type,
        placement_group,
        start_time,
        summary_status,
        row_number() over (partition by '', id order by _fivetran_synced desc) as rn
    from base
)

select *
from final
where rn = 1