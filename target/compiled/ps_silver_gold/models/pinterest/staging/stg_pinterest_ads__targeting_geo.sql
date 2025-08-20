with base as (

    select *
    from `secure-electron-279822.pinterest_ads.targeting_geo`

), fields as (

    select
        country_id,
        country_name,
        _fivetran_synced,
        cast('' as string) as source_relation
    from base

), final as (
    select
        source_relation,
        cast(_fivetran_synced as timestamp) as _fivetran_synced,
        cast(country_id as string) as country_id,
        country_name
    from fields
)

select *
from final