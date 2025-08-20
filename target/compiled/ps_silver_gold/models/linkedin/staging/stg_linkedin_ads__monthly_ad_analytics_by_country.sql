with base as (

    select * 
    from secure-electron-279822.linkedin_ads.monthly_ad_analytics_by_member_country

),

macro as (

    select
        campaign_id,
        month as date_month,
        clicks,
        member_country,
        impressions,
        conversion_value_in_local_currency,
        cost_in_local_currency,
        cost_in_usd,
        cast(null as string) as external_website_conversions,
        one_click_leads,
        cast('' as string) as source_relation
    from base

),

fields as (
    
    select 
        source_relation,

        -- Convert 'YYYY-MM' → first day of month
        parse_date('%Y-%m-%d', concat(split(date_month, '-')[offset(0)], '-', lpad(split(date_month, '-')[offset(1)], 2, '0'), '-01')) as date_month,

        campaign_id,
        member_country as member_country_geo_id,
        clicks,
        impressions,
        cost_in_usd as cost,
        coalesce(cast(conversion_value_in_local_currency as float64), 0) as conversion_value_in_local_currency,
        coalesce(cast(external_website_conversions as int64), 0) as external_website_conversions,
        coalesce(cast(one_click_leads as int64), 0) as one_click_leads

    from macro
)

select *
from fields