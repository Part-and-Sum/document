WITH base AS (
    SELECT
        ad_group_criterion_criterion_id,
        ad_group_id,
        metrics_cost_micros,
        metrics_clicks,
        metrics_impressions,
        metrics_conversions,
        metrics_conversions_value,
        segments_date
    FROM
        `secure-electron-279822.google_ads_2025.ads_KeywordBasicStats_8196795413`
),
blue_vine AS (
    SELECT
        ad_group_criterion_criterion_id,
        ad_group_id,
        metrics_cost_micros,
        metrics_clicks,
        metrics_impressions,
        metrics_conversions,
        metrics_conversions_value,
        segments_date
    FROM
        `secure-electron-279822.google_bluevine.ads_KeywordBasicStats_2828502255`
)
SELECT
    *
FROM
    base
UNION ALL
SELECT
    *
FROM
    blue_vine