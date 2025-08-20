
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_keyword`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        DISTINCT ad_group_criterion_criterion_id,
        ad_group_criterion_keyword_match_type,
        ad_group_criterion_keyword_text
    FROM
        `secure-electron-279822.google_ads_2025.ads_Keyword_8196795413`
),
blue_vine AS (
    SELECT
        DISTINCT ad_group_criterion_criterion_id,
        ad_group_criterion_keyword_match_type,
        ad_group_criterion_keyword_text
    FROM
        `secure-electron-279822.google_bluevine.ads_Keyword_2828502255`
)
SELECT
    *
FROM
    base
UNION ALL
SELECT
    *
FROM
    blue_vine
    );
  