with base as (
    select *
    from `secure-electron-279822.pinterest_ads.pin_promotion_history`
), 

fields as (
    select
        _fivetran_synced as _fivetran_synced,
        ad_group_id as ad_group_id,
        ad_account_id as ad_account_id,
        cast(null as STRING) as android_deep_link,
        cast(null as STRING) as click_tracking_url,
        created_time as created_time,
        creative_type as creative_type,
        destination_url as destination_url,
        id as id,
        cast(null as STRING) as ios_deep_link,
        cast(null as BOOLEAN) as is_pin_deleted,
        cast(null as BOOLEAN) as is_removable,
        name as name,
        pin_id as pin_id,
        cast(null as STRING) as review_status,
        status as status,
        cast(null as TIMESTAMP) as updated_time,
        cast(null as STRING) as view_tracking_url,
        cast('' as STRING) as source_relation
    from base
), 

final as (
    select
        source_relation,
        cast(id as STRING) as pin_promotion_id,
        cast(ad_account_id as STRING) as advertiser_id,
        cast(ad_group_id as STRING) as ad_group_id,
        created_time as created_at,
        destination_url,

        -- base_url = part before '?'
        SPLIT(destination_url, '?')[SAFE_OFFSET(0)] as base_url,

        -- Cleaned url host:
        -- remove android-app://, http://, https:// first
        -- then get the part before first '/' or entire string if no '/'
        (
            select
                case 
                    when strpos(clean_url, '/') > 0 
                    then substr(clean_url, 0, strpos(clean_url, '/') - 1)
                    else clean_url
                end
            from (
                select
                    replace(
                        replace(
                            replace(destination_url, 'android-app://', ''), 
                        'http://', ''), 
                    'https://', '') as clean_url
            )
        ) as url_host,

        -- url_path: everything after the host part until '?' or end of string
        (
            select
                '/' || 
                case 
                    when strpos(path_and_params, '?') > 0
                    then substr(path_and_params, 0, strpos(path_and_params, '?') - 1)
                    else path_and_params
                end
            from (
                select
                    substr(
                        replace(
                            replace(destination_url, 'http://', ''),
                        'https://', ''),
                        ifnull(nullif(strpos(replace(replace(destination_url, 'http://', ''), 'https://', ''), '/'), 0), length(replace(replace(destination_url, 'http://', ''), 'https://', ''))) + 1
                    ) as path_and_params
            )
        ) as url_path,

        -- UTM parameters extraction
        nullif(
            SPLIT(SPLIT(destination_url, 'utm_source=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)], ''
        ) as utm_source,

        nullif(
            SPLIT(SPLIT(destination_url, 'utm_medium=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)], ''
        ) as utm_medium,

        nullif(
            SPLIT(SPLIT(destination_url, 'utm_campaign=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)], ''
        ) as utm_campaign,

        nullif(
            SPLIT(SPLIT(destination_url, 'utm_content=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)], ''
        ) as utm_content,

        nullif(
            SPLIT(SPLIT(destination_url, 'utm_term=')[SAFE_OFFSET(1)], '&')[SAFE_OFFSET(0)], ''
        ) as utm_term,

        name as pin_name,
        cast(pin_id as STRING) as pin_id,
        status as pin_status,
        creative_type,
        _fivetran_synced,

        row_number() over (partition by source_relation, id order by _fivetran_synced desc) = 1 as is_most_recent_record

    from fields
)

select *
from final