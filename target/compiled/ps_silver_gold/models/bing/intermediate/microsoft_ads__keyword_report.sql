with report as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__keyword_daily_report`
), 

keywords as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__keyword_history`
    where is_most_recent_record = TRUE
),

ads as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__ad_history`
    where is_most_recent_record = TRUE
), 

ad_groups as (
    select *
    from `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__ad_group_history`
    where is_most_recent_record = TRUE
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
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        ads.ad_name,
        report.ad_id,
        keywords.keyword_name,
        report.keyword_id,
        keywords.match_type,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,
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
    left join ads
        on report.ad_id = ads.ad_id
        and report.source_relation = ads.source_relation
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join keywords
        on report.keyword_id = keywords.keyword_id
        and report.source_relation = keywords.source_relation
    left join mapping
        on cast(report.account_id as string) = cast(mapping.account_id as string)
    group by all
)

select * from joined