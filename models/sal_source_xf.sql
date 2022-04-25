{{ config(materialized='table') }}

SELECT
    person_id,
    email,
    lead_source,
    is_hand_raiser,
    working_date,
    mql_most_recent_date,
    person_status,
    country,
    global_region,
    company_size_rev
FROM {{ref('person_source_xf')}}
WHERE person_owner_id != '00Ga0000003Nugr'
AND working_date IS NOT null
AND email NOT LIKE '%act-on.com'
AND lead_source = 'Marketing'
AND person_status  NOT IN ('Current Customer','Partner','Bad Data','No Fit')