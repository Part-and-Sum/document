with
    base as (
        select distinct
            ad_group_criterion_criterion_id,
            ad_group_criterion_keyword_match_type,
            ad_group_criterion_keyword_text
        from
            `secure-electron-279822.google_ads_2025.ads_Keyword_8196795413`
    )
select
    *
from
    base