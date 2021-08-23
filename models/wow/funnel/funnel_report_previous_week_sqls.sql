{{ config(materialized='table') }}

WITH previous_week AS (
SELECT
week
FROM "acton".dbt_actonmarketing.date_base_xf
WHERE day=CURRENT_DATE-14
), base AS (
SELECT DISTINCT
sql_source_xf.opportunity_id AS sql_id,
sql_source_xf.created_date AS sql_date
FROM "acton".dbt_actonmarketing.sql_source_xf 
LEFT JOIN "acton".dbt_actonmarketing.date_base_xf ON
sql_source_xf.created_date=date_base_xf.day
LEFT JOIN previous_week ON 
date_base_xf.week=previous_week.week
WHERE previous_week.week IS NOT null
)

SELECT *
FROM base