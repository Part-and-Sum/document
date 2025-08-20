-- stg_tiktok_ads__ad_group_history

WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.adgroup_history`
), 

final AS (
  SELECT
    -- Identifiers
    adgroup_id                           AS ad_group_id,
    CAST(updated_at AS TIMESTAMP)       AS updated_at,
    advertiser_id,
    campaign_id,

    -- Targeting & Audience
    age_groups,
    gender,
    languages,
    audience_type,
    action_days,
    action_categories,
    interest_category_v_2               AS interest_category,

    -- Ad Group Info
    adgroup_name                         AS ad_group_name,
    display_name,
    category,
    landing_page_url,

    -- Budget & Frequency
    budget,
    frequency,
    frequency_schedule,

    -- Latest Record Flag
    ROW_NUMBER() OVER (
      PARTITION BY adgroup_id
      ORDER BY updated_at DESC
    ) = 1                               AS is_most_recent_record

  FROM base
)

SELECT *
FROM final