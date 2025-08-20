with base as (
    select * 
    from `secure-electron-279822.pinterest_ads.ad_group_report`
),

final as (
    select
        cast('' as string) as source_relation,
        date_trunc(date, day) as date_day,
        cast(ad_group_id as string) as ad_group_id,
        ad_group_name,
        ad_group_status,
        cast(campaign_id as string) as campaign_id,
        cast(advertiser_id as string) as advertiser_id,  -- <== MISSING COMMA FIXED HERE
        coalesce(impression_1, 0) + coalesce(impression_2, 0) as impressions,
        coalesce(clickthrough_1, 0) + coalesce(clickthrough_2, 0) as clicks,
        coalesce(spend_in_micro_dollar, 0) / 1000000.0 as spend,
        coalesce(total_conversions, 0) as total_conversions,
        coalesce(total_conversions_quantity, 0) as total_conversions_quantity,
        coalesce(total_conversions_value_in_micro_dollar, 0) / 1000000.0 as total_conversions_value
    from base
)

select * from final