{{ config(
	tags=['legacy'],
	
        alias = alias('glp_aum', legacy_model=True),
        partition_by = ['block_date'],
        file_format = 'delta',
        unique_key = ['block_date', 'minute'],
        post_hook='{{ expose_spells(\'["arbitrum"]\',
                                    "project",
                                    "gmx",
                                    \'["1chioku"]\') }}'
        )
}}

{% set project_start_date = '2021-08-31 08:13' %}

/*
Stablecoin holings AUM = poolAmounts * current_price
Directional holdings Long Exposure = (available_assets * current_price) + shorts_outstanding_notional
Directional holdings Neutral Exposure = (longs) + ((current_price - shorts_entry_price) * COALESCE((shorts_outstanding_notional / shorts_entry_price),0)) - shorts_outstanding_notional
*/

SELECT -- This query calculates the AUM of each component of GLP
    minute,
    block_date,
    
    frax_available_assets * frax_current_price AS frax_aum,
    
    usdt_available_assets * usdt_current_price AS usdt_aum,

    (wbtc_available_assets * wbtc_current_price) + wbtc_shorts_outstanding_notional AS wbtc_long_exposure_aum,
    (wbtc_longs) + ((wbtc_current_price - wbtc_shorts_entry_price) * COALESCE((wbtc_shorts_outstanding_notional / wbtc_shorts_entry_price),0)) - wbtc_shorts_outstanding_notional AS wbtc_neutral_exposure_aum,

    usdc_available_assets * usdc_current_price AS usdc_aum,

    (uni_available_assets * uni_current_price) + uni_shorts_outstanding_notional AS uni_long_exposure_aum,
    (uni_longs) + ((uni_current_price - uni_shorts_entry_price) * COALESCE((uni_shorts_outstanding_notional / uni_shorts_entry_price),0)) - uni_shorts_outstanding_notional AS uni_neutral_exposure_aum,

    (link_available_assets * link_current_price) + link_shorts_outstanding_notional AS link_long_exposure_aum,
    (link_longs) + ((link_current_price - link_shorts_entry_price) * COALESCE((link_shorts_outstanding_notional / link_shorts_entry_price),0)) - link_shorts_outstanding_notional AS link_neutral_exposure_aum,
    
    (weth_available_assets * weth_current_price) + weth_shorts_outstanding_notional AS weth_long_exposure_aum,
    (weth_longs) + ((weth_current_price - weth_shorts_entry_price) * COALESCE((weth_shorts_outstanding_notional / weth_shorts_entry_price),0)) - weth_shorts_outstanding_notional AS weth_neutral_exposure_aum,
    
    dai_available_assets * dai_current_price AS dai_aum
FROM {{ref('gmx_arbitrum_glp_components_legacy')}}
WHERE minute >= '{{project_start_date}}'