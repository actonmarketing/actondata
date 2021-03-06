
{{ config(materialized='table') }}

WITH person_base AS (

    SELECT
        contact_id AS person_id,
        email,
        is_hand_raiser,
        mql_created_date,
        contact_owner_id AS owner_id,
        channel_lead_creation,
        medium_lead_creation,
        source_lead_creation,
        lead_source,
        marketing_created_date,
        contact_status AS person_status,
        company_size_rev,
        global_region,
        segment,
        account_id,
        channel_bucket
    FROM {{ref('contact_source_xf')}}
    WHERE marketing_created_date >= '2021-01-01'
    UNION ALL
    SELECT
        lead_id AS person_id,
        email,
        is_hand_raiser,
        mql_created_date,
        lead_owner_id AS owner_id,
        channel_lead_creation,
        medium_lead_creation,
        source_lead_creation,
        lead_source,
        marketing_created_date,
        lead_status AS person_status,
        company_size_rev,
        global_region,
        segment,
        person_account_id,
        channel_bucket
    FROM {{ref('lead_source_xf')}}
    WHERE is_converted = false
    AND marketing_created_date >= '2021-01-01'
)

SELECT 
    person_base.person_id,
    person_base.email,
    person_base.is_hand_raiser,
    person_base.channel_bucket,
    person_base.mql_created_date,
    person_base.owner_id,
    person_base.channel_lead_creation,
    person_base.medium_lead_creation,
    person_base.source_lead_creation,
    person_base.lead_source,
    person_base.marketing_created_date,
    person_base.company_size_rev,
    person_base.global_region,
    person_base.segment,
    person_base.account_id,
    person_base.person_status,
    account_base.is_current_customer, 
    opp_base.opportunity_id,
    opp_base.close_date,
    opp_base.is_won,
    opp_base.created_date AS opp_created_date,
    opp_base.discovery_date,
    opp_base.stage_name,
    opp_base.acv,
    opp_base.opp_lead_source,
    opp_base.type,
    opp_base.is_closed,
    CASE 
        WHEN mql_created_date IS NOT null AND email NOT LIKE '%act-on%' AND lead_source = 'Marketing' THEN 1
        ELSE 0
    END AS is_mql,
    CASE 
        WHEN mql_created_date IS NOT null AND email NOT LIKE '%act-on%' AND lead_source = 'Marketing' AND person_status NOT IN ('Current Customer','Partner','Bad Data','No Fit') THEN 1
        ELSE 0
    END AS is_sal,
    CASE
        WHEN opp_base.created_date IS NOT null AND opp_base.type = 'New Business' AND opp_base.stage_name NOT IN ('Closed - Duplicate','Closed - Admin Remove') THEN 1
        ELSE 0
    END AS is_sql,
    CASE
        WHEN opp_base.discovery_date IS NOT null AND opp_base.type = 'New Business' AND opp_base.stage_name NOT IN ('Closed - Duplicate','Closed - Admin Remove') THEN 1
        ELSE 0
    END AS is_sqo,
    CASE
        WHEN opp_base.is_closed = true AND opp_base.is_won = false THEN 1
        ELSE 0
    END AS is_cl,
    CASE
        WHEN opp_base.is_closed = true AND opp_base.is_won = true THEN 1
        ELSE 0
    END AS is_cw
FROM person_base
LEFT JOIN {{ref('opp_source_xf')}} AS opp_base ON
person_base.account_id=opp_base.account_id
LEFT JOIN {{ref('account_source_xf')}} AS account_base ON
person_base.account_id=account_base.account_id
WHERE opportunity_id IS NOT null
ORDER BY 4