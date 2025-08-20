with report as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__basic_ad`
), 

conversion_report as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`int_facebook_ads__conversions`
), 

accounts as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__account_history`
    where is_most_recent_record = true
),

campaigns as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__campaign_history`
    where is_most_recent_record = true
),

ads as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__ad_history`
    where is_most_recent_record = true
),

mapping as (
    select *
    from `ps-silver-gold.mapping.mapping`
    WHERE ad_platform = 'meta'
),

joined as (
    select 
        report.date_day,
        report.account_id,
        mapping.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        campaigns.start_at,
        campaigns.end_at,
        campaigns.status,
        campaigns.daily_budget,
        campaigns.lifetime_budget,
        campaigns.budget_remaining,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(coalesce(conversion_report.conversions, 0)) as conversions,
        sum(coalesce(conversion_report.conversions_value, 0)) as conversions_value
    from report
    left join conversion_report
        on report.date_day = conversion_report.date_day
        and report.ad_id = conversion_report.ad_id
        and report.source_relation = conversion_report.source_relation
    left join ads
        on report.ad_id = ads.ad_id
        and report.source_relation = ads.source_relation
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
        and ads.source_relation = campaigns.source_relation
    left join mapping
        on cast(report.account_id as string) = cast(mapping.account_id as string)
    group by all
)

select *
from joined