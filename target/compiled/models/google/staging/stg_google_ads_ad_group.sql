with
    base as (
        select distinct
            ad_group_id,
            ad_group_name,
            ad_group_status,
            ad_group_type,
            campaign_id
        from
            `secure-electron-279822.google_ads_2025.ads_AdGroup_8196795413`
    )
select
    *
from
    base