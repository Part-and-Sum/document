with
    base as (
        select distinct
            campaign_id,
            campaign_name,
            campaign_advertising_channel_type,
            campaign_status,
            customer_id
        from
            `secure-electron-279822.google_ads_2025.ads_Campaign_8196795413`
    )
select
    *
from
    base