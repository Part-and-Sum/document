
  
    

    create or replace table `ps-silver-gold`.`staging_google_ads_dev`.`stg_google_ads_account`
      
    
    

    OPTIONS()
    as (
      with
    base as (
        select
            *
        from
            `secure-electron-279822.fact_lookups.google_ads_accounts`
    )
select
    account_name,
    customer_id
from
    base
    );
  