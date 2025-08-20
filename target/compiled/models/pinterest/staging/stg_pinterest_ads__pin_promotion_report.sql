with base as (
    select *
    from `secure-electron-279822.pinterest_ads.pin_promotion_targeting_report`
),

fields as (
    select
        _fivetran_synced,
        date,
        targeting_type,
        targeting_value,
        ad_group_id,
        advertiser_id,
        campaign_id,
        pin_promotion_id,
        clickthrough_2,
        impression_2,
        total_checkout_value_in_micro_dollar,  -- as an example of spend proxy
        total_conversions,
        total_conversions_quantity,
        total_conversions_value_in_micro_dollar,
        cast('' as string) as source_relation
    from base
),

final as (
    select
        source_relation,
        cast(_fivetran_synced as timestamp) as _fivetran_synced,
        cast(date as timestamp) as date_day,
        targeting_type,
        targeting_value,
        cast(ad_group_id as string) as ad_group_id,
        cast(advertiser_id as string) as advertiser_id,
        cast(campaign_id as string) as campaign_id,
        cast(pin_promotion_id as string) as pin_promotion_id,
        coalesce(impression_2, 0) as impressions,
        coalesce(clickthrough_2, 0) as clicks,
        coalesce(total_checkout_value_in_micro_dollar, 0) / 1000000.0 as spend,  -- Using checkout value as spend proxy
        coalesce(total_conversions, 0) as total_conversions,
        coalesce(total_conversions_quantity, 0) as total_conversions_quantity,
        coalesce(total_conversions_value_in_micro_dollar, 0) / 1000000.0 as total_conversions_value
    from fields
)

select *
from final