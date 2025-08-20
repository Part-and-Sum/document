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
        keyword_id AS keyword_id,
        keyword_text AS keyword_text,
        CAST(
            NULL AS STRING
        ) AS final_url,
        CAST(
            NULL AS STRING
        ) AS search_term,
        CAST(
            NULL AS STRING
        ) AS search_term_id,
        CAST(
            NULL AS STRING
        ) AS engagements,
        CAST(
            NULL AS STRING
        ) AS video_views,
        CAST(
            NULL AS STRING
        ) AS video_completes,
        CAST(
            NULL AS STRING
        ) AS match_type,
        clicks,
        impressions,
        spend_usd AS spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`silver_google_ads_dev`.`google_ads__keyword_report`
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
        creative_id AS keyword_id,
        creative_name AS keyword_text,
        base_url AS final_url,
        CAST(
            utm_term AS STRING
        ) AS search_term,
        CAST(
            NULL AS STRING
        ) AS search_term_id,
        CAST(
            NULL AS STRING
        ) AS engagements,
        CAST(
            NULL AS STRING
        ) AS video_views,
        CAST(
            NULL AS STRING
        ) AS video_completes,
        CAST(
            NULL AS STRING
        ) AS match_type,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__url_report`
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
        keyword_id,
        keyword_name,
        CAST(
            NULL AS STRING
        ) AS final_url,
        CAST(
            NULL AS STRING
        ) AS search_term,
        CAST(
            NULL AS STRING
        ) AS search_term_id,
        CAST(
            NULL AS STRING
        ) AS engagements,
        CAST(
            NULL AS STRING
        ) AS video_views,
        CAST(
            NULL AS STRING
        ) AS video_completes,
        CAST(
            NULL AS STRING
        ) AS match_type,
        clicks,
        impressions,
        spend,
        conversions,
        conversions_value
    FROM
        `ps-silver-gold`.`silver_bing_ads_dev`.`microsoft_ads__keyword_report`
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
    bing_stats