with account as (

    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__account_history`
    where is_latest_version

),

campaign as (

    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__campaign_history`
    where is_latest_version

),

report as (

    select *,
        external_website_conversions + one_click_leads as total_conversions
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__ad_analytics_by_campaign`

),

mapping as (
    select *
    from `ps-silver-gold.mapping.mapping`
    WHERE ad_platform = 'linkedin'
),

final as (

    select 
        report.source_relation,
        report.date_day,
        account.account_id,
        account.account_name,
        account.version_tag,
        account.currency,
        account.status,
        account.type,
        account.last_modified_at,
        account.created_at,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,        
        sum(report.total_conversions) as total_conversions,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.cost) as cost,
        sum(coalesce(report.conversion_value_in_local_currency, 0)) as conversion_value_in_local_currency,
        sum(coalesce(report.external_website_conversions, 0)) as external_website_conversions,
        sum(coalesce(report.one_click_leads, 0)) as one_click_leads

    from report 
    left join campaign 
        on report.campaign_id = campaign.campaign_id
        and report.source_relation = campaign.source_relation
    left join account 
        on campaign.account_id = account.account_id
        and campaign.source_relation = account.source_relation
    LEFT JOIN mapping
        ON CAST(account.account_id AS STRING) = CAST(mapping.account_id AS STRING)
    GROUP BY ALL

)

select *
from final