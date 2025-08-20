WITH base AS (
    SELECT *
    FROM `secure-electron-279822.linkedin_ads.campaign_group_history`
),

macro AS (
    SELECT
        account_id AS account_id,
        CAST(NULL AS BOOL) AS backfilled,
        created_time AS created_time,
        id AS id,
        last_modified_time AS last_modified_time,
        name AS name,
        CAST(NULL AS TIMESTAMP) AS run_schedule_end,
        CAST(NULL AS TIMESTAMP) AS run_schedule_start,
        CAST(NULL AS STRING) AS status,
        CAST('' AS STRING) AS source_relation
    FROM base
),

fields AS (
    SELECT 
        source_relation,
        id AS campaign_group_id,
        name AS campaign_group_name,
        account_id,
        status,
        backfilled AS is_backfilled,
        CAST(run_schedule_start AS TIMESTAMP) AS run_schedule_start_at,
        CAST(run_schedule_end AS TIMESTAMP) AS run_schedule_end_at,
        CAST(last_modified_time AS TIMESTAMP) AS last_modified_at,
        CAST(created_time AS TIMESTAMP) AS created_at,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY last_modified_time DESC) = 1 AS is_latest_version
    FROM macro
)

SELECT *
FROM fields