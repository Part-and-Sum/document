-- stg_tiktok_ads__campaign_history

WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.campaign_history`
),

final AS (
  SELECT
    campaign_id,
    CAST(updated_at AS TIMESTAMP) AS updated_at,
    advertiser_id,
    campaign_name,
    campaign_type,
    split_test_variable,
    ROW_NUMBER() OVER (PARTITION BY campaign_id ORDER BY updated_at DESC) = 1 AS is_most_recent_record
  FROM base
)

SELECT *
FROM final