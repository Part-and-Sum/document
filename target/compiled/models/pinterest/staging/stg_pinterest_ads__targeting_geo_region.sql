with base as (

    select *
    from `secure-electron-279822.pinterest_ads.targeting_geo_region`

), fields as (

    select
        _fivetran_synced,
        country_id,
        region_id,
        region_name,
        cast('' as string) as source_relation
    from base

), final as (
    select
        source_relation,
        cast(_fivetran_synced as timestamp) as _fivetran_synced,
        cast(country_id as string) as country_id,
        cast(region_id as string) as region_id,
        region_name
    from fields
)

select *
from final