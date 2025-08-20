
  
    

    create or replace table `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__country_report`
      
    
    

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
demographics_country AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__demographics_country`
),
demographics_country_actions AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__demographics_country_actions`
),
country_conversions AS (
    SELECT
        source_relation,
        account_id,
        country_id,
        date_day,
        SUM(conversions) AS conversions
    FROM
        `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__demographics_country_actions`
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
        dc.source_relation,
        dc.date_day,
        dc.country_id,
        dc.country,
        dc.account_id,
        mapping.account_name,
        /* A.account_name, A.business_country_code AS account_business_country_code, A.timezone_name AS account_timezone, A.timezone_offset_hours_utc AS account_timezone_offset_hours_utc, A.currency AS account_currency, A.min_daily_budget AS account_min_daily_budget, */
        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,
        SUM(
            dc.impressions
        ) AS impressions,
        SUM(
            dc.clicks
        ) AS clicks,
        SUM(
            dc.spend
        ) AS spend,
        SUM(
            dc.reach
        ) AS reach,
        SUM(
            dc.frequency
        ) AS frequency,
        SUM(COALESCE(cc.conversions, 0)) AS conversions
    FROM
        demographics_country dc
        LEFT JOIN country_conversions cc
        ON dc.country_id = cc.country_id
        AND dc.account_id = cc.account_id
        AND dc.date_day = cc.date_day
        AND dc.source_relation = cc.source_relation
        /* left join accounts a on dc.account_id = a.account_id and dc.source_relation = a.source_relation */
        LEFT JOIN mapping
        ON CAST(
            dc.account_id AS STRING
        ) = CAST(
            mapping.account_id AS STRING
        )
    GROUP BY
        ALL
)
SELECT
    *
FROM
    joined
    );
  