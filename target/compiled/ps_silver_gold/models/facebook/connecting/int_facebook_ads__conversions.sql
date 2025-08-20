with actions_report as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__basic_ad_actions`
),

action_values_report as (
    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__basic_ad_action_values`
),
action_metrics as (
    select
        source_relation,
        ad_id,
        date_day,
        sum(conversions) as conversions
    from actions_report
    where action_type in (
        'onsite_conversion.purchase',
        'onsite_conversion.lead_grouped',
        'offsite_conversion.fb_pixel_purchase',
        'offsite_conversion.fb_pixel_lead',
        'offsite_conversion.fb_pixel_custom'
    )
    group by all
),

action_value_metrics as (
    select
        source_relation,
        ad_id,
        date_day,
        sum(conversions_value) as conversions_value
    from action_values_report
    where action_type in (
        'onsite_conversion.purchase',
        'onsite_conversion.lead_grouped',
        'offsite_conversion.fb_pixel_purchase',
        'offsite_conversion.fb_pixel_lead',
        'offsite_conversion.fb_pixel_custom'
    )
    group by all
),

metrics_join as (
    select
        am.source_relation,
        am.ad_id,
        am.date_day,
        am.conversions,
        avm.conversions_value
    from action_metrics am
    left join action_value_metrics avm
      on am.source_relation = avm.source_relation
      and am.ad_id = avm.ad_id
      and am.date_day = avm.date_day
)

select * from metrics_join