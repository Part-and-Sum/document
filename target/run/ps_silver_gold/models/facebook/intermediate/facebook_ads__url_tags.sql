
  
    

    create or replace table `ps-silver-gold`.`silver_facebook_ads_dev`.`facebook_ads__url_tags`
      
    
    

    OPTIONS()
    as (
      with base as (

    select *
    from `ps-silver-gold`.`staging_facebook_ads_dev`.`stg_facebook_ads__creative_history`
    where is_most_recent_record = true
), 

required_fields as (

    select
        source_relation,
        _fivetran_id,
        creative_id,
        url_tags
    from base
    where url_tags is not null
), 

cleaned_json as (

    select
        source_relation,
        _fivetran_id,
        creative_id,
        json_extract_array(replace(trim(url_tags, '"'),'\\','')) as cleaned_url_tags
    from required_fields
), 

unnested as (

    select 
        source_relation,
        _fivetran_id, 
        creative_id, 
        url_tag_element
    from cleaned_json,
    unnest(cleaned_url_tags) as url_tag_element
    where cleaned_url_tags is not null
), 

fields as (

    select
        source_relation,
        _fivetran_id,
        creative_id,
        json_extract_scalar(url_tag_element, '$.key') as key,
        json_extract_scalar(url_tag_element, '$.value') as value,
        json_extract_scalar(url_tag_element, '$.type') as type
    from unnested
)

select *
from fields
    );
  