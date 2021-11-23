{{ config(materialized='table') }}

SELECT
lead_id,
email,
lead_source,
is_converted,
is_hand_raiser,
mql_created_date,
mql_most_recent_date,
lead_status,
country
FROM {{ref('lead_source_xf')}}
--FROM "acton".dbt_actonmarketing.lead_source_xf
WHERE lead_owner != '00Ga0000003Nugr'
AND mql_created_date IS NOT null
AND email NOT LIKE '%act-on.com'
AND lead_source = 'Marketing'
AND lead_status  NOT IN ('Current Customer','Partner','Bad Data','No Fit')
