WITH base AS (

    SELECT * 
    FROM secure-electron-279822.linkedin_ads.geo

),

macro AS (

    SELECT
        id AS id,
        value AS value,
        CAST('' AS STRING) AS source_relation
    FROM base

),

fields AS (
    
    SELECT 
        source_relation,
        id AS geo_id,
        value
    FROM macro

)

SELECT *
FROM fields