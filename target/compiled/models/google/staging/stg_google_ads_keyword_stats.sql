with
    base as (
        select
            ad_group_criterion_criterion_id,
            ad_group_id,
            metrics_cost_micros,
            metrics_clicks,
            metrics_impressions,
            metrics_conversions,
            metrics_conversions_value,
            segments_date
        from
            `secure-electron-279822.google_ads_2025.ads_KeywordBasicStats_8196795413`
    )
select
    *
from
    base