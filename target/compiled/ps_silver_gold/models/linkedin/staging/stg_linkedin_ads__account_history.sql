WITH base AS (
    SELECT *
    FROM `secure-electron-279822.linkedin_ads.account_history`
),

macro AS (
    SELECT
        created_time AS created_time,
        currency AS currency,
        id AS id,
        last_modified_time AS last_modified_time,
        name AS name,
        CAST(NULL AS STRING) AS status,
        CAST(NULL AS STRING) AS type,
        version_tag AS version_tag,
        CAST('' AS STRING) AS source_relation
    FROM base
),

fields AS (
    SELECT 
        source_relation,
        id AS account_id,
        name AS account_name,
        currency,
        CAST(version_tag AS NUMERIC) AS version_tag,
        status,
        type,
        CAST(last_modified_time AS TIMESTAMP) AS last_modified_at,
        CAST(created_time AS TIMESTAMP) AS created_at,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY last_modified_time DESC) = 1 AS is_latest_version
    FROM macro
)

SELECT *
FROM fields