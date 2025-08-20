with report as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__geographic_daily_report`
),  

campaigns as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__campaign_history`
    where is_most_recent_record = TRUE
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
        report.country,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        campaigns.type as campaign_type,
        campaigns.time_zone as campaign_timezone,
        campaigns.status as campaign_status,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
        report.location_id,
        report.goal,
        report.language as geo_language,
        campaigns.budget as campaign_budget,
        campaigns.budget_id as campaign_budget_id,
        campaigns.budget_type as campaign_budget_type,
        campaigns.language as campaign_language,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(report.conversions) as conversions,
        sum(report.conversions_value) as conversions_value,
        sum(report.all_conversions) as all_conversions,
        sum(report.all_conversions_value) as all_conversions_value
    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join mapping
        on cast(report.account_id as string) = cast(mapping.account_id as string)
    group by all)

select *
from joined