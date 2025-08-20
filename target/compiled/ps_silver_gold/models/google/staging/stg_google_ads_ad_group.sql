WITH all_ad_group_history AS (
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_ads_2025.ads_AdGroup_8196795413`
    UNION ALL
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id,
        _DATA_DATE
    FROM
        `secure-electron-279822.google_bluevine.ads_AdGroup_2828502255`
),
ranked_ad_groups AS (
    SELECT
        ad_group_id,
        ad_group_name,
        ad_group_status,
        ad_group_type,
        campaign_id,
        customer_id,
        _DATA_DATE,
        ROW_NUMBER() over(
            PARTITION BY ad_group_id,
            campaign_id,
            customer_id
            ORDER BY
                _DATA_DATE DESC
        ) AS rn
    FROM
        all_ad_group_history
)
SELECT
    ad_group_id,
    ad_group_name,
    ad_group_status,
    ad_group_type,
    campaign_id,
    customer_id
FROM
    ranked_ad_groups
WHERE
    rn = 1