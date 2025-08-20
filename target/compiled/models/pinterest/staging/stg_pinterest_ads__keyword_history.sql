WITH base AS (
    SELECT * 
    FROM `secure-electron-279822.pinterest_ads.keyword_history`
),

fields AS (
    SELECT
        _fivetran_id,
        _fivetran_synced,
        ad_group_id,
        advertiser_id,
        archived,
        bid,
        campaign_id,
        id,
        match_type,
        parent_type,
        value,
        CAST('' AS STRING) AS source_relation
    FROM base
),

final AS (
    SELECT
        source_relation,
        CAST(id AS STRING) AS keyword_id,
        value AS keyword_value,
        _fivetran_id,
        _fivetran_synced,
        CAST(ad_group_id AS STRING) AS ad_group_id,
        CAST(advertiser_id AS STRING) AS advertiser_id,
        archived,
        bid,
        CAST(campaign_id AS STRING) AS campaign_id,
        match_type,
        parent_type,
        ROW_NUMBER() OVER (PARTITION BY source_relation, id ORDER BY _fivetran_synced DESC) = 1 AS is_most_recent_record
    FROM fields
)

SELECT *
FROM final