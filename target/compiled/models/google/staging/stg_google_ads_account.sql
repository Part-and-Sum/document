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