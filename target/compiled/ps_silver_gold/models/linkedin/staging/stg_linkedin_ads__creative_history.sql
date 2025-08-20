with base as (

    select *
    from `secure-electron-279822.linkedin_ads.creative_history`

), macro as (

    select 
        campaign_id,
        created_at as created_time,
        timestamp(null) as created_at,
        id,
        timestamp(null) as last_modified_time,
        last_modified_at,
        intended_status,
        cast(null as string) as status,
        text_ad_landing_page,
        spotlight_landing_page,
        cast('' as string) as source_relation
    from base

), fields as (

    select
        source_relation,
        id as creative_id,
        campaign_id,
        coalesce(status, intended_status) as status,
        coalesce(text_ad_landing_page, spotlight_landing_page) as click_uri,
        cast(coalesce(last_modified_time, last_modified_at) as timestamp) as last_modified_at,
        cast(coalesce(created_time, created_at) as timestamp) as created_at,
        case 
            when text_ad_landing_page is not null then 'text_ad'
            when spotlight_landing_page is not null then 'spotlight'
            else null
        end as click_uri_type
    from macro

), url_fields as (

    select 
        *,
        row_number() over (partition by creative_id order by last_modified_at desc) = 1 as is_latest_version,

        split(click_uri, '?')[safe_offset(0)] as base_url,

        cast(
            split(
                split(
                    replace(replace(replace(click_uri, 'android-app://', ''), 'http://', ''), 'https://', ''), 
                    '/'
                )[safe_offset(0)], 
                '?'
            )[safe_offset(0)] as string
        ) as url_host,

        '/' || cast(
            split(
                right(
                    replace(replace(click_uri, 'http://', ''), 'https://', ''),
                    length(
                        replace(replace(click_uri, 'http://', ''), 'https://', '')
                    )
                    - coalesce(
                        nullif(
                            strpos(replace(replace(click_uri, 'http://', ''), 'https://', ''), '/'),
                            0
                        ),
                        strpos(replace(replace(click_uri, 'http://', ''), 'https://', ''), '?') - 1
                    )
                ),
                '?'
            )[safe_offset(0)] as string
        ) as url_path,

        nullif(split(split(click_uri, 'utm_source=')[safe_offset(1)], '&')[safe_offset(0)], '') as utm_source,
        nullif(split(split(click_uri, 'utm_medium=')[safe_offset(1)], '&')[safe_offset(0)], '') as utm_medium,
        nullif(split(split(click_uri, 'utm_campaign=')[safe_offset(1)], '&')[safe_offset(0)], '') as utm_campaign,
        nullif(split(split(click_uri, 'utm_content=')[safe_offset(1)], '&')[safe_offset(0)], '') as utm_content,
        nullif(split(split(click_uri, 'utm_term=')[safe_offset(1)], '&')[safe_offset(0)], '') as utm_term

    from fields
)

select *
from url_fields