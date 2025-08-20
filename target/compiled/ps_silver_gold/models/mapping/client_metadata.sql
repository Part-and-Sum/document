

-- Ensure the external table exists by calling the macro


-- Dummy SELECT so dbt parses the model
SELECT 
    'external table ensured' AS status,
    CURRENT_TIMESTAMP() AS created_at