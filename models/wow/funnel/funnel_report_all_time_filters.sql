{{ config(materialized='table') }}

WITH base AS (

    SELECT DISTINCT
        global_region,
        company_size_rev,
        lead_source,
        segment,
        industry,
        channel_bucket,
        created_date AS date
    FROM {{ref('funnel_report_all_time_leads')}}
    UNION ALL
    SELECT DISTINCT
        global_region,
        company_size_rev,
        lead_source,
        segment,
        industry,
        channel_bucket,
        mql_date
    FROM {{ref('funnel_report_all_time_mqls')}}
    UNION ALL
    SELECT DISTINCT
        global_region,
        company_size_rev,
        lead_source,
        segment,
        industry,
        channel_bucket,
        sal_date
    FROM {{ref('funnel_report_all_time_sals')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        sql_date
    FROM {{ref('funnel_report_all_time_sqls')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        sqo_date
    FROM {{ref('funnel_report_all_time_sqos')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        demo_date
    FROM {{ref('funnel_report_all_time_demo')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        voc_date
    FROM {{ref('funnel_report_all_time_voc')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        closing_date
    FROM {{ref('funnel_report_all_time_closing')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        won_date
    FROM {{ref('funnel_report_all_time_won')}}
    UNION ALL
    SELECT DISTINCT
        account_global_region,
        company_size_rev,
        opp_lead_source,
        segment,
        industry,
        channel_bucket,
        lost_date
    FROM {{ref('funnel_report_all_time_lost')}}

)

SELECT DISTINCT
    CASE
        WHEN global_region IS null THEN 'blank'
        ELSE global_region
    END AS global_region,
    CASE
        WHEN company_size_rev IS null THEN 'blank'
        ELSE company_size_rev
    END AS company_size_rev,
    CASE
        WHEN lead_source IS null THEN 'blank'
        ELSE lead_source
    END AS lead_source,
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
    END AS channel_bucket,
    date
FROM base