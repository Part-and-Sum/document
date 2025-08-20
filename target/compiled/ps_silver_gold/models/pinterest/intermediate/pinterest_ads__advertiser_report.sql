with report as (

    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__advertiser_report`

), 

advertisers as (

    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__advertiser_history`
    where is_most_recent_record = True

), 

mapping as (

    select *
    from `ps-silver-gold.mapping.mapping`
    where ad_platform = 'pinterest'

), 

fields as (

    select
        report.source_relation,
        report.date_day,
        advertisers.advertiser_name,
        report.advertiser_id,
        advertisers.currency_code,
        advertisers.country,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value

    from report
    left join advertisers
        on cast(report.advertiser_id as STRING) = cast(advertisers.advertiser_id as STRING)
        and report.source_relation = advertisers.source_relation
    left join mapping
        on cast(report.advertiser_id as STRING) = cast(mapping.account_id as STRING)

    group by all
)

select *
from fields