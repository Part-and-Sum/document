with report as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__campaign_report`
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
        advertisers.advertiser_name,
        advertisers.advertiser_id,
        campaigns.campaign_name,
        report.campaign_id,
        campaigns.campaign_status,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value
    from report
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
    group by all
),

final as (
    select
        fields.*,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,
    from fields
    left join mapping
        on cast(fields.advertiser_id as STRING) = cast(mapping.account_id as STRING)
)

select *
from final