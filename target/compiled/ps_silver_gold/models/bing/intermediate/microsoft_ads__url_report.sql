WITH report AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__ad_daily_report`
),

ads AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__ad_history`
    WHERE is_most_recent_record = TRUE
),

ad_groups AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__ad_group_history`
    WHERE is_most_recent_record = TRUE
),

campaigns AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__campaign_history`
    WHERE is_most_recent_record = TRUE
),

accounts AS (
    SELECT *
    FROM `ps-silver-gold`.`staging_bing_ads_dev`.`stg_microsoft_ads__account_history`
    WHERE is_most_recent_record = TRUE
),

mapping AS (
    SELECT *
    FROM `ps-silver-gold.mapping.mapping`
    WHERE ad_platform = 'bing'
),

joined AS (
    SELECT
        report.source_relation,
        report.date_day,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        ads.ad_name,
        report.ad_id,
        report.device_os,
        report.device_type,
        report.network,
        report.currency_code,

        -- Macro expands into multiple fields with aliases:
        
  SPLIT(ads.final_url, '?')[SAFE_OFFSET(0)] AS base_url,

  CAST(
    SPLIT(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REGEXP_REPLACE(ads.final_url, r'^(android-app://)', ''),
          r'^(https?://)', ''
        ), r'/.*$', ''
      ),
    '?')[SAFE_OFFSET(0)] AS STRING
  ) AS url_host,

  CONCAT(
    '/',
    CAST(
      REGEXP_EXTRACT(
        REGEXP_REPLACE(ads.final_url, r'^(https?://)', ''),
        r'[^/]+(/[^?]*)'
      ) AS STRING
    )
  ) AS url_path,

  NULLIF(
    SPLIT(SPLIT(ads.final_url, 'utm_source=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)],
    ''
  ) AS utm_source,

  NULLIF(
    SPLIT(SPLIT(ads.final_url, 'utm_medium=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)],
    ''
  ) AS utm_medium,

  NULLIF(
    SPLIT(SPLIT(ads.final_url, 'utm_campaign=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)],
    ''
  ) AS utm_campaign,

  NULLIF(
    SPLIT(SPLIT(ads.final_url, 'utm_content=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)],
    ''
  ) AS utm_content,

  NULLIF(
    SPLIT(SPLIT(ads.final_url, 'utm_term=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)],
    ''
  ) AS utm_term
,

        mapping.client_name,
        mapping.client_id,
        mapping.ad_platform,
        mapping.sub_client_name,

        SUM(report.clicks) AS clicks,
        SUM(report.impressions) AS impressions,
        SUM(report.spend) AS spend,
        SUM(report.conversions) AS conversions,
        SUM(report.conversions_value) AS conversions_value,
        SUM(report.all_conversions) AS all_conversions,
        SUM(report.all_conversions_value) AS all_conversions_value

    FROM report
    LEFT JOIN ads
        ON report.ad_id = ads.ad_id
        AND report.source_relation = ads.source_relation
    LEFT JOIN ad_groups
        ON report.ad_group_id = ad_groups.ad_group_id
        AND report.source_relation = ad_groups.source_relation
    LEFT JOIN campaigns
        ON report.campaign_id = campaigns.campaign_id
        AND report.source_relation = campaigns.source_relation
    LEFT JOIN accounts
        ON report.account_id = accounts.account_id
        AND report.source_relation = accounts.source_relation
    LEFT JOIN mapping
        ON CAST(report.account_id AS STRING) = CAST(mapping.account_id AS STRING)
    GROUP BY ALL
)

SELECT *
FROM joined
WHERE base_url IS NOT NULL