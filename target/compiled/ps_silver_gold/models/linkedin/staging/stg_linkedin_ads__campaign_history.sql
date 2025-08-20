WITH base AS (

    SELECT *
    FROM `secure-electron-279822.linkedin_ads.campaign_history`

), macro AS (

    SELECT 
        account_id AS account_id,
        CAST(NULL AS BOOL) AS audience_expansion_enabled,
        campaign_group_id AS campaign_group_id,
        CAST(NULL AS STRING) AS cost_type,
        created_time AS created_time,
        CAST(NULL AS STRING) AS creative_selection,
        CAST(NULL AS FLOAT64) AS daily_budget_amount,
        CAST(NULL AS STRING) AS daily_budget_currency_code,
        CAST(NULL AS STRING) AS format,
        id AS id,
        last_modified_time AS last_modified_time,
        CAST(NULL AS STRING) AS locale_country,
        CAST(NULL AS STRING) AS locale_language,
        name AS name,
        CAST(NULL AS STRING) AS objective_type,
        CAST(NULL AS BOOL) AS offsite_delivery_enabled,
        CAST(NULL AS STRING) AS optimization_target_type,
        CAST(NULL AS TIMESTAMP) AS run_schedule_end,
        CAST(NULL AS TIMESTAMP) AS run_schedule_start,
        CAST(NULL AS STRING) AS status,
        CAST(NULL AS STRING) AS type,
        CAST(NULL AS FLOAT64) AS unit_cost_amount,
        CAST(NULL AS STRING) AS unit_cost_currency_code,
        version_tag AS version_tag,
        CAST('' AS STRING) AS source_relation
    FROM base

), fields AS (

    SELECT 
        source_relation,
        id AS campaign_id,
        name AS campaign_name,
        CAST(version_tag AS NUMERIC) AS version_tag,
        campaign_group_id,
        account_id,
        status,
        type,
        cost_type,
        creative_selection,
        daily_budget_amount,
        daily_budget_currency_code,
        unit_cost_amount,
        unit_cost_currency_code,
        format,
        locale_country,
        locale_language,
        objective_type,
        optimization_target_type,
        audience_expansion_enabled AS is_audience_expansion_enabled,
        offsite_delivery_enabled AS is_offsite_delivery_enabled,
        CAST(run_schedule_start AS TIMESTAMP) AS run_schedule_start_at,
        CAST(run_schedule_end AS TIMESTAMP) AS run_schedule_end_at,
        CAST(last_modified_time AS TIMESTAMP) AS last_modified_at,
        CAST(created_time AS TIMESTAMP) AS created_at,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY last_modified_time DESC) = 1 AS is_latest_version
    FROM macro

)

SELECT *
FROM fields