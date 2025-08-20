

WITH stats AS (

    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_gender_stats`
),
gender AS (
    SELECT
        DISTINCT ad_group_criterion_criterion_id,
        ad_group_criterion_gender_type
    FROM
        `secure-electron-279822.google_ads_2025.ads_Gender_8196795413`
),
accounts AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account`
),
campaigns AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_campaign`
),
ad_groups AS (
    SELECT
        *
    FROM
        `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_ad_group`
),
mapping AS (
    SELECT
        *
    FROM
        `ps-silver-gold.mapping.mapping`
),
fields AS (
    SELECT
        stats.segments_date AS date_day,
        campaigns.customer_id AS account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
        gender.ad_group_criterion_criterion_id,
        gender.ad_group_criterion_gender_type,
        ROUND(SUM(stats.metrics_cost_micros) / 1e6, 2) AS spend_usd,
        SUM(
            stats.metrics_clicks
        ) AS clicks,
        SUM(
            stats.metrics_impressions
        ) AS impressions,
        SUM(
            stats.metrics_conversions
        ) AS conversions,
        SUM(
            stats.metrics_conversions_value
        ) AS conversions_value,
        ROUND(
            safe_divide(SUM(stats.metrics_conversions), SUM(stats.metrics_clicks)) * 100,
            2
        ) AS daily_CVR_percent,
        ROUND(
            safe_divide(SUM(stats.metrics_clicks), SUM(stats.metrics_impressions)) * 100,
            2
        ) AS daily_CTR_percent,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_clicks)),
            2
        ) AS daily_CPC_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_impressions)) * 1000,
            2
        ) AS daily_CPM_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_cost_micros) / 1e6, SUM(stats.metrics_conversions)),
            2
        ) AS daily_CPA_usd,
        ROUND(
            safe_divide(SUM(stats.metrics_conversions_value), SUM(stats.metrics_cost_micros) / 1e6) * 100,
            2
        ) AS daily_ROAS_usd,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
    FROM
        stats
        LEFT JOIN gender
        ON gender.ad_group_criterion_criterion_id = stats.ad_group_criterion_criterion_id
        LEFT JOIN ad_groups
        ON stats.ad_group_id = ad_groups.ad_group_id
        LEFT JOIN campaigns
        ON ad_groups.campaign_id = campaigns.campaign_id
        LEFT JOIN accounts
        ON campaigns.customer_id = accounts.customer_id
        LEFT JOIN mapping
        ON CAST(
            mapping.account_id AS string
        ) = cast(campaigns.customer_id as string)
    GROUP BY
        stats.segments_date,
        accounts.account_name,
        campaigns.customer_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        ad_groups.ad_group_status,
        ad_groups.ad_group_type,
        gender.ad_group_criterion_criterion_id,
        gender.ad_group_criterion_gender_type,
        mapping.client_id,
        mapping.client_name,
        mapping.sub_client_name,
        mapping.ad_platform
)
SELECT
    *
FROM
    fields