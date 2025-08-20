WITH base AS (
    SELECT *
    FROM `secure-electron-279822.pinterest_ads.campaign_history`
), 

fields AS (
    SELECT
        _fivetran_synced,
        created_time,
        default_ad_group_budget_in_micro_currency,
        is_automated_campaign,
        is_campaign_budget_optimization,
        is_flexible_daily_budgets,
        id,
        advertiser_id,
        name,
        status,
        start_time,
        end_time,
        daily_spend_cap,
        lifetime_spend_cap,
        objective_type,
        CAST('' AS STRING) AS source_relation
    FROM base
), 

final AS (
    SELECT
        source_relation, 
        CAST(id AS STRING) AS campaign_id,
        name AS campaign_name,
        CAST(advertiser_id AS STRING) AS advertiser_id,
        default_ad_group_budget_in_micro_currency,
        is_automated_campaign,
        is_campaign_budget_optimization,
        is_flexible_daily_budgets,
        status AS campaign_status,
        _fivetran_synced,
        created_time AS created_at,
        start_time,
        end_time,
        daily_spend_cap,
        lifetime_spend_cap,
        objective_type,
        ROW_NUMBER() OVER (PARTITION BY source_relation, id ORDER BY _fivetran_synced DESC) = 1 AS is_most_recent_record
    FROM fields
)

SELECT *
FROM final