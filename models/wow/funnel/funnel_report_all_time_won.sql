{{ config(materialized='table') }}

WITH base AS (

    SELECT DISTINCT
        opp_sales_source_xf.opportunity_id AS won_id,
        CONCAT('https://acton.my.salesforce.com/',opp_sales_source_xf.opportunity_id) AS won_url,
        opp_sales_source_xf.close_date AS won_date,
        acv,
        CASE
        WHEN account_global_region IS null THEN 'blank'
        ELSE account_global_region
    END AS account_global_region,
    CASE
        WHEN company_size_rev IS null THEN 'blank'
        ELSE company_size_rev
    END AS company_size_rev,
    CASE
        WHEN opp_lead_source IS null THEN 'blank'
        ELSE opp_lead_source
    END AS opp_lead_source,
    CASE
        WHEN segment IS null THEN 'blank'
        ELSE segment
    END AS segment,
    CASE
        WHEN industry IS null THEN 'blank'
        ELSE industry
    END AS industry,
    CASE
        WHEN channel_bucket IS null THEN 'blank'
        ELSE channel_bucket
    END AS channel_bucket
    FROM {{ref('opp_sales_source_xf')}}
    WHERE type = 'New Business'

)

SELECT *
FROM base