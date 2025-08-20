-- stg_tiktok_ads__ad_report_hourly

WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.ad_report_hourly`
), 

final AS (
  SELECT  
    -- Identifiers & Timestamp
    ad_id,
    CAST(stat_time_hour AS TIMESTAMP) AS stat_time_hour,

    -- Performance Metrics
    impressions,
    clicks,
    ctr,
    cpc,
    cpm,
    spend,
    reach,

    -- Conversion Metrics
    conversion,
    cost_per_conversion,
    conversion_rate,

    -- Engagement Metrics
    likes,
    comments,
    shares,
    profile_visits,
    follows,

    -- Video Metrics
    video_play_actions,
    video_watched_2_s,
    video_watched_6_s,
    video_views_p_25,
    video_views_p_50,
    video_views_p_75,
    average_video_play,
    average_video_play_per_user
  FROM base
)

SELECT *
FROM final