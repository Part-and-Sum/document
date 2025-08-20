WITH base AS (
    SELECT * 
    FROM secure-electron-279822.pinterest_ads.advertiser_report
),

final AS (
    SELECT
        CAST('' AS STRING) AS source_relation, 
        DATE_TRUNC(date, DAY) AS date_day,
        CAST(advertiser_id AS STRING) AS advertiser_id,
        COALESCE(impression_1, 0) + COALESCE(impression_2, 0) AS impressions,
        COALESCE(clickthrough_1, 0) + COALESCE(clickthrough_2, 0) AS clicks,
        COALESCE(spend_in_micro_dollar, 0) / 1000000.0 AS spend,
        COALESCE(total_conversions, 0) AS total_conversions,
        COALESCE(total_conversions_quantity, 0) AS total_conversions_quantity,
        COALESCE(total_conversions_value_in_micro_dollar, 0) / 1000000.0 AS total_conversions_value
    FROM base
)

SELECT *
FROM final