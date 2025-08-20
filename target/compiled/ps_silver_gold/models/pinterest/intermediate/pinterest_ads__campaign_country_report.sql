with report as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__pin_promotion_report`
    where lower(targeting_type) = 'country'
),

countries as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__targeting_geo`
),

campaigns as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__campaign_history`
    where is_most_recent_record = True
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
        countries.country_name,
        countries.country_id,
        report.campaign_id,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value
    from report
    left join countries
        on report.targeting_value = countries.country_id
        and report.source_relation = countries.source_relation
    group by all
),

final as (
    select
        fields.*,
        advertisers.advertiser_name,
        advertisers.advertiser_id,
        campaigns.campaign_name,
        campaigns.campaign_status,
        campaigns.daily_spend_cap,
        campaigns.lifetime_spend_cap,
        campaigns.created_at as campaign_created_at,
        campaigns.default_ad_group_budget_in_micro_currency,
        campaigns.end_time as campaign_end_time,
        campaigns.is_campaign_budget_optimization,
        campaigns.is_flexible_daily_budgets,
        campaigns.objective_type as campaign_objective_type,
        campaigns.start_time as campaign_start_time,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name
    from fields
    left join campaigns
        on fields.campaign_id = campaigns.campaign_id
        and fields.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
    left join mapping
        on cast(advertisers.advertiser_id as STRING) = cast(mapping.account_id as STRING)
)

select *
from final