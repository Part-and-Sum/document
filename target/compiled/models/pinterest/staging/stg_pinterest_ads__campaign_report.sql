WITH base AS (
    SELECT * 
    FROM `secure-electron-279822.pinterest_ads.campaign_report`
),

fields AS (
    SELECT
        _fivetran_synced,
        advertiser_id,
        campaign_id,
        campaign_name,
        campaign_status,
        clickthrough_1,
        clickthrough_2,
        date,
        impression_1,
        impression_2,
        spend_in_micro_dollar,
        total_conversions,
        total_conversions_quantity,
        total_conversions_value_in_micro_dollar,
        CAST('' AS STRING) AS source_relation
    FROM base
),

final AS (
    SELECT
        source_relation, 
        DATE_TRUNC(date, DAY) AS date_day,
        CAST(campaign_id AS STRING) AS campaign_id,
        campaign_name,
        campaign_status,
        CAST(advertiser_id AS STRING) AS advertiser_id,
        COALESCE(impression_1,0) + COALESCE(impression_2,0) AS impressions,
        COALESCE(clickthrough_1,0) + COALESCE(clickthrough_2,0) AS clicks,
        COALESCE(spend_in_micro_dollar, 0) / 1000000.0 AS spend,
        COALESCE(total_conversions, 0) AS total_conversions,
        COALESCE(total_conversions_quantity, 0) AS total_conversions_quantity,
        COALESCE(total_conversions_value_in_micro_dollar, 0) / 1000000.0 AS total_conversions_value
    FROM fields
)

SELECT *
FROM final