WITH google_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        ad_id,
        ad_name,
        ad_type,
        CAST(
            NULL AS STRING
        ) AS creative_name,
        CAST(
            NULL AS STRING
        ) AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        CAST(
            NULL AS STRING
        ) AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value,
        video_views,
        engagements,
        video_completion
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__ad_report`
),
facebook_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_set_id AS ad_group_id,
        ad_set_name AS ad_group_name,
        ad_id,
        ad_name,
        CAST(
            NULL AS STRING
        ) AS ad_type,
        creative_name,
        base_url AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        CAST(
            NULL AS STRING
        ) AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion,
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__url_report`
),
tiktok_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        ad_id,
        ad_name,
        CAST(
            NULL AS STRING
        ) AS ad_type,
        CAST(
            NULL AS STRING
        ) AS creative_name,
        base_url AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        CAST(
            NULL AS STRING
        ) AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        spend,
        conversion AS conversions,
        NULL AS conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion,
    FROM
        `ps-silver-gold`.`silver_tiktok_ads_dev`.`tiktok_ads__url_report`
),
bing_stats AS (
    SELECT
        date_day,
        client_id,
        client_name,
        ad_platform,
        sub_client_name,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        ad_id,
        ad_name,
        ad_type,
        CAST(
            NULL AS STRING
        ) AS creative_name,
        CAST(
            NULL AS STRING
        ) AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        CAST(
            NULL AS STRING
        ) AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value,
        NULL AS video_views,
        NULL AS engagements,
        NULL AS video_completion,
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__ad_report`
),
linkedin_stats AS (
    SELECT
        date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_group_id AS int64
        ) AS campaign_id,
        campaign_group_name AS campaign_name,
        NULL AS ad_group_id,
        CAST(
            NULL AS STRING
        ) AS ad_group_name,
        creative_id AS ad_id,
        CAST(
            NULL AS STRING
        ) AS ad_name,
        CAST(
            NULL AS STRING
        ) AS ad_type,
        CAST(
            NULL AS STRING
        ) AS creative_name,
        click_uri AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        click_uri_type AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        cost AS spend,
        total_conversions AS conversions,
        CAST(
            NULL AS numeric
        ) AS conversions_value,
        CAST(
            NULL AS int64
        ) AS video_views,
        CAST(
            NULL AS int64
        ) AS engagements,
        CAST(
            NULL AS int64
        ) AS video_completion,
    FROM
        `ps-silver-gold`.`silver_linkedin_ads_dev`.`linkedin_ads__creative_report`
),
stackadapt_stats AS (
    SELECT
        DATE(DATE) AS date_day,
        CAST(
            client_id AS STRING
        ) AS client_id,
        client_name,
        ad_platform,
        sub_client_name,
        CAST(
            campaign_id AS int64
        ) AS campaign_id,
        campaign_name,
        CAST(
            campaign_group_id AS int64
        ) AS ad_group_id,
        campaign_group_name AS ad_group_name,
        CAST(
            advertiser_id AS int64
        ) AS ad_id,
        creative_name AS ad_name,
        channels AS ad_type,
        CAST(
            NULL AS STRING
        ) AS creative_name,
        CAST(
            NULL AS STRING
        ) AS creative_url,
        CAST(
            NULL AS STRING
        ) AS tagline,
        CAST(
            NULL AS STRING
        ) AS creative_type,
        CAST(
            NULL AS STRING
        ) AS creative_size,
        clicks,
        impressions,
        spend,
        conversions,
        NULL AS conversions_value,
        video_start AS video_views,
        engagements,
        video_completes AS video_completion,
    FROM
        `ps-silver-gold`.`silver_stackadapt_ads_dev`.`unified_data`
    WHERE
        ad_platform = 'stackadapt'
)
SELECT
    *
FROM
    google_stats
UNION ALL
SELECT
    *
FROM
    facebook_stats
UNION ALL
SELECT
    *
FROM
    tiktok_stats
UNION ALL
SELECT
    *
FROM
    bing_stats
UNION ALL
SELECT
    *
FROM
    linkedin_stats
UNION ALL
SELECT
    *
FROM
    stackadapt_stats