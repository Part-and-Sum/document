
  
    

    create or replace table `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__region_report`
      
    
    

    OPTIONS()
    as (
      WITH accounts AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__account_history`
    WHERE
        is_most_recent_record = TRUE
),
demographics_region AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__demographics_region`
),
demographics_region_actions AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__demographics_region_actions`
),
region_conversions AS (
    SELECT
        source_relation,
        account_id,
        region_id,
        date_day,
        SUM(conversions) AS conversions
    FROM
        demographics_region_actions
    WHERE
        action_type IN (
            'onsite_conversion.purchase',
            'onsite_conversion.lead_grouped',
            'offsite_conversion.fb_pixel_purchase',
            'offsite_conversion.fb_pixel_lead',
            'offsite_conversion.fb_pixel_custom'
        )
    GROUP BY
        ALL
),
mapping AS (
    SELECT
        *
    FROM
        `ps-silver-gold.mapping.mapping`
    WHERE
        ad_platform = 'meta'
),
joined AS (
    SELECT
        dr.date_day,
        dr.region_id,
        dr.region,
        dr.account_id,
        m.account_name,
        /*
                a.business_state as account_business_state,
                a.business_country_code as account_business_country_code,
                a.timezone_name as account_timezone,
                a.timezone_offset_hours_utc as account_timezone_offset_hours_utc,
                a.currency as account_currency,
                a.min_daily_budget as account_min_daily_budget,
        */
        m.client_name,
        m.client_id,
        m.ad_platform,
        m.sub_client_name,
        SUM(
            dr.impressions
        ) AS impressions,
        SUM(
            dr.clicks
        ) AS clicks,
        SUM(
            dr.spend
        ) AS spend,
        SUM(
            dr.reach
        ) AS reach,
        SUM(
            dr.frequency
        ) AS frequency,
        SUM(COALESCE(rc.conversions, 0)) AS conversions
    FROM
        demographics_region dr
        LEFT JOIN region_conversions rc
        ON dr.region_id = rc.region_id
        AND dr.account_id = rc.account_id
        AND dr.date_day = rc.date_day
        AND dr.source_relation = rc.source_relation
        /*left join accounts a
                on dr.account_id = a.account_id
                and dr.source_relation = a.source_relation*/
        LEFT JOIN mapping m
        ON CAST(
            dr.account_id AS STRING
        ) = CAST(
            m.account_id AS STRING
        )
    GROUP BY
        ALL
)
SELECT
    *
FROM
    joined
    );
  