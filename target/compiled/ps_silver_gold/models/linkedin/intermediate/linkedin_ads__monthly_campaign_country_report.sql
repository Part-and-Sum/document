with campaign as (
    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__campaign_history`
    where is_latest_version
),

campaign_group as (
    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__campaign_group_history`
    where is_latest_version
),

account as (
    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__account_history`
    where is_latest_version
),

geo as (
    select *
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__geo`
),

report as (
    select *,
        external_website_conversions + one_click_leads as total_conversions
    from `ps-silver-gold`.`staging_linkedin_ads_dev`.`stg_linkedin_ads__monthly_ad_analytics_by_country`
),

mapping as (
    select *
    from `ps-silver-gold.mapping.mapping`
    WHERE ad_platform = 'linkedin'
),

final as (

    select 
        report.source_relation,
        report.date_month,
        geo.value as country_name,
        report.campaign_id,
        campaign.campaign_name,
        campaign.version_tag,
        campaign_group.campaign_group_id,
        campaign_group.campaign_group_name,
        account.account_id,
        account.account_name,
        campaign.status as campaign_status,
        campaign_group.status as campaign_group_status,
        campaign.type as campaign_type,
        campaign.cost_type,
        campaign.creative_selection,
        campaign.daily_budget_amount,
        campaign.daily_budget_currency_code,
        campaign.unit_cost_amount,
        campaign.unit_cost_currency_code,
        account.currency as account_currency,
        campaign.format,
        campaign.locale_country as campaign_locale_country,
        campaign.locale_language as campaign_locale_language,
        campaign.objective_type,
        campaign.optimization_target_type,
        campaign.is_audience_expansion_enabled,
        campaign.is_offsite_delivery_enabled,
        campaign.run_schedule_start_at,
        campaign.run_schedule_end_at,
        campaign.last_modified_at,
        campaign.created_at,
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,   
        sum(report.total_conversions) as total_conversions,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.cost) as cost,
        sum(coalesce(report.conversion_value_in_local_currency, 0)) as conversion_value_in_local_currency,
        sum(coalesce(external_website_conversions, 0)) as external_website_conversions,
        sum(coalesce(one_click_leads, 0)) as one_click_leads

    from report 
    left join geo
        on geo.geo_id = report.member_country_geo_id
        and report.source_relation = geo.source_relation
    left join campaign 
        on report.campaign_id = campaign.campaign_id
        and report.source_relation = campaign.source_relation
    left join campaign_group
        on campaign.campaign_group_id = campaign_group.campaign_group_id
        and campaign.source_relation = campaign_group.source_relation
    left join account 
        on campaign.account_id = account.account_id
        and campaign.source_relation = account.source_relation
    LEFT JOIN mapping
        ON CAST(account.account_id AS STRING) = CAST(mapping.account_id AS STRING)

    group by all

)

select *
from final