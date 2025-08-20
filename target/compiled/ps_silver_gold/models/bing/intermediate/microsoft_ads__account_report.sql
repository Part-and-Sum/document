with report as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__account_daily_report`
), 

accounts as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__account_history`
    where is_most_recent_record = TRUE
),

mapping as (
    select *
    from `ps-silver-gold.mapping.mapping`
    where ad_platform = 'bing'
),

joined as (
    select
        report.source_relation,
        report.date_day,
        accounts.account_name,
        report.account_id,
        accounts.time_zone as account_timezone,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.client_id,
        mapping.ad_platform,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(report.conversions) as conversions,
        sum(report.conversions_value) as conversions_value,
        sum(report.all_conversions) as all_conversions
        -- all_conversion_value is not available for the account_report
    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join mapping
        on cast(report.account_id as string) = cast(mapping.account_id as string)
    group by all
)

select *
from joined