-- stg_tiktok_ads__advertiser

WITH base AS (
  SELECT *
  FROM `secure-electron-279822.tiktok_ads.advertiser`
), 

final AS (
  SELECT   
    -- Identifiers
    id                        AS advertiser_id,
    name                      AS advertiser_name,

    -- Contact Info
    contacter,
    email,
    cellphone_number,
    telephone_number,
    address,

    -- Company Info
    company,
    description,
    industry,
    country,
    currency,
    language,
    timezone,
    balance
  FROM base
)

SELECT *
FROM final