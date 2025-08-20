
WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.ad_history`
),

fields AS (
  SELECT
    ad_id,
    ad_name,
    adgroup_id,
    advertiser_id,
    call_to_action,
    campaign_id,
    click_tracking_url,
    impression_tracking_url,
    landing_page_url,
    updated_at
  FROM base
),

final AS (
  SELECT
    ad_id,
    CAST(updated_at AS TIMESTAMP)              AS updated_at,
    adgroup_id                                 AS ad_group_id,
    advertiser_id,
    campaign_id,
    ad_name,
    call_to_action,
    click_tracking_url,
    impression_tracking_url,

    -- strip off everything from '?' onward
    SPLIT(landing_page_url, '?')[OFFSET(0)]    AS base_url,

    -- host = the part after protocol up to first slash
    REGEXP_EXTRACT(
      landing_page_url,
      r'^(?:https?://|android-app://)?([^/]+)'
    )                                           AS url_host,

    -- path = slash + everything after host, up to '?'
    COALESCE(
      REGEXP_EXTRACT(
        landing_page_url,
        r'^(?:https?://|android-app://)?[^/]+(/[^?]*)'
      ),
      '/'  -- if there was no slash/path, return just '/'
    )                                           AS url_path,

    -- UTM parameters via regex
    NULLIF(REGEXP_EXTRACT(landing_page_url, r'[?&]utm_source=([^&]+)'), '')   AS utm_source,
    NULLIF(REGEXP_EXTRACT(landing_page_url, r'[?&]utm_medium=([^&]+)'), '')   AS utm_medium,
    NULLIF(REGEXP_EXTRACT(landing_page_url, r'[?&]utm_campaign=([^&]+)'), '') AS utm_campaign,
    NULLIF(REGEXP_EXTRACT(landing_page_url, r'[?&]utm_content=([^&]+)'), '')  AS utm_content,
    NULLIF(REGEXP_EXTRACT(landing_page_url, r'[?&]utm_term=([^&]+)'), '')     AS utm_term,

    landing_page_url,

    -- flag the most recent per ad_id
    ROW_NUMBER() OVER (
      PARTITION BY ad_id
      ORDER BY CAST(updated_at AS TIMESTAMP) DESC
    ) = 1                                       AS is_most_recent_record

  FROM fields
)

SELECT *
FROM final