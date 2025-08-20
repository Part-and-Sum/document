
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_search_term`
      
    
    

    OPTIONS()
    as (
      WITH base AS (
    SELECT
        DISTINCT ad_group_ad_ad_id,
        search_term_view_search_term,
        segments_search_term_match_type
    FROM
        `secure-electron-279822.google_ads_2025.ads_SearchQueryConversionStats_8196795413`
),
blue_vine AS (
    SELECT
        DISTINCT ad_group_ad_ad_id,
        search_term_view_search_term,
        segments_search_term_match_type
    FROM
        `secure-electron-279822.google_bluevine.ads_SearchQueryConversionStats_2828502255`
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
  