{{ config(
    tags=['dunesql'],
    schema = 'compound_v2_ethereum',
    alias = alias('votes'),
    materialized = 'table',
    file_format = 'delta',
    post_hook='{{ expose_spells(\'["ethereum"]\',
                                "project",
                                "compound_v2",
                                \'["soispoke"]\') }}'
    )
}}

{% set blockchain = 'ethereum' %}
{% set project = 'compound' %}
{% set project_version = 'v2' %}
{% set dao_name = 'DAO: Compound' %}
{% set dao_address = '0xc0da02939e1441f497fd74f78ce7decb17b66529' %}

WITH cte_sum_votes as
(SELECT sum(votes/1e18) as sum_votes,
        proposalId
FROM {{ source('compound_v2_ethereum', 'GovernorBravoDelegate_evt_VoteCast') }}
GROUP BY proposalId)

SELECT
    '{{blockchain}}' as blockchain,
    '{{project}}' as project,
    '{{project_version}}' as version,
    vc.evt_block_time as block_time,
    date_trunc('DAY', vc.evt_block_time) AS block_date,
    CAST(date_trunc('month', vc.evt_block_time) as date) as block_month,
    vc.evt_tx_hash as tx_hash,
    '{{dao_name}}' as dao_name,
    {{dao_address}} as dao_address,
    vc.proposalId as proposal_id,
    vc.votes/1e18 as votes,
    (votes/1e18) * (100) / (csv.sum_votes) as votes_share,
    p.symbol as token_symbol,
    p.contract_address as token_address,
    vc.votes/1e18 * p.price as votes_value_usd,
    vc.voter as voter_address,
    CASE WHEN vc.support = 0 THEN 'against'
         WHEN vc.support = 1 THEN 'for'
         WHEN vc.support = 2 THEN 'abstain'
         END AS support,
    vc.reason
FROM {{ source('compound_v2_ethereum', 'GovernorBravoDelegate_evt_VoteCast') }} vc
LEFT JOIN cte_sum_votes csv ON vc.proposalId = csv.proposalId
LEFT JOIN {{ source('prices', 'usd') }} p ON p.minute = date_trunc('minute', vc.evt_block_time)
    AND p.symbol = 'COMP'
    AND p.blockchain ='ethereum'