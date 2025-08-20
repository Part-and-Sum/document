-- stg_tiktok_ads__campaign_report_hourly

WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.campaign_report_hourly`
),

final AS (
  SELECT  
    campaign_id,
    CAST(stat_time_hour AS TIMESTAMP) AS stat_time_hour,

    -- Performance Metrics
    cpc,
    cpm,
    ctr,
    impressions,
    clicks,
    spend,
    reach,
    conversion,
    cost_per_conversion,
    conversion_rate,

    -- Engagement Metrics
    likes,
    comments,
    shares,
    profile_visits,
    follows,
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