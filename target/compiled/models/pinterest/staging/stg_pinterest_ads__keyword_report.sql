with base as (
    select * 
    from secure-electron-279822.pinterest_ads.keyword_report
),

fields as (
    select
        _fivetran_synced as _fivetran_synced,
        ad_group_id as ad_group_id,
        ad_group_name as ad_group_name,
        ad_group_status as ad_group_status,
        advertiser_id as advertiser_id,
        campaign_id as campaign_id,
        clickthrough_2 as clickthrough_2,
        date as date,
        impression_2 as impression_2,
        keyword_id as keyword_id,
        pin_promotion_id as pin_promotion_id,
        total_conversions as total_conversions,
        total_conversions_quantity as total_conversions_quantity,
        total_conversions_value_in_micro_dollar as total_conversions_value_in_micro_dollar,
        cast('' as STRING) as source_relation
    from base
),

final as (
    select
        source_relation,
        date_trunc(date, DAY) as date_day,
        cast(keyword_id as STRING) as keyword_id,
        cast(pin_promotion_id as STRING) as pin_promotion_id,
        cast(ad_group_id as STRING) as ad_group_id,
        ad_group_name,
        ad_group_status,
        cast(campaign_id as STRING) as campaign_id,
        cast(advertiser_id as STRING) as advertiser_id,
        coalesce(impression_2, 0) as impressions,
        coalesce(clickthrough_2, 0) as clicks,
        coalesce(total_conversions, 0) as total_conversions,
        coalesce(total_conversions_quantity, 0) as total_conversions_quantity,
        coalesce(total_conversions_value_in_micro_dollar, 0) / 1000000.0 as total_conversions_value
    from fields
)

select * from final