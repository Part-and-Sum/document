with report as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__pin_promotion_report`
), 

pins as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__pin_promotion_history`
    where is_most_recent_record = True
), 

ad_groups as (
    select *
    from `ps-silver-gold`.`staging_pinterest_ads_dev`.`stg_pinterest_ads__ad_group_history`
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

joined as (
    select
        report.source_relation,
        report.date_day,
        campaigns.advertiser_id,
        advertisers.advertiser_name,
        report.campaign_id,
        campaigns.campaign_name,
        campaigns.campaign_status,
        report.ad_group_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_status,
        pins.destination_url,
        pins.creative_type,
        report.pin_promotion_id,
        pins.pin_name,
        pins.pin_status,
        pins.base_url,
        pins.url_host,
        pins.url_path,
        pins.utm_source,
        pins.utm_medium,
        pins.utm_campaign,
        pins.utm_content,
        pins.utm_term,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value
    from report 
    left join pins 
        on report.pin_promotion_id = pins.pin_promotion_id
        and report.source_relation = pins.source_relation
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    left join campaigns 
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
    where pins.destination_url is not null
    group by all
),

final as (
    select
        joined.*,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name
    from joined
    left join mapping
        on cast(joined.advertiser_id as string) = cast(mapping.account_id as string)
)

select * 
from final