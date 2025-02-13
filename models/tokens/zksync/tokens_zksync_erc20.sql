{{ config(
        schema = 'tokens_zksync'
        , alias = alias('erc20')
        , tags=['static', 'dunesql']
        )
}}

SELECT contract_address, symbol, decimals
FROM (VALUES
        (0x000000000000000000000000000000000000800a, 'ETH', 18)
        ,(0x5aea5775959fbc2557cc8789bc1bf90a239d9a91, 'WETH', 18)
        ,(0x3355df6d4c9c3035724fd0e3914de96a5a83aaf4, 'USDC.e', 6)
        ,(0x2039bb4116b4efc145ec4f0e2ea75012d6c0f181, 'BUSD', 18)
        ,(0x493257fd37edb34451f62edf8d2a0c418852ba4c, 'USDT.e', 6)
        ,(0x47ef4a5641992a72cfd57b9406c9d9cefee8e0c4, 'ZAT', 18)
        ,(0x1bbd33384869b30a323e15868ce46013c82b86fb, 'nETH', 8)
        ,(0x8e86e46278518efc1c5ced245cba2c7e3ef11557, 'USD+', 6)
        ,(0x47260090ce5e83454d5f05a0abbb2c953835f777, 'SPACE', 18)
        ,(0x0e97c7a0f8b2c9885c8ac9fc6136e829cbc21d42, 'MUTE', 18)
        ,(0xe0ef1c039a36ec77339e7277ecd4d48e57b61eec, 'ySYNC', 18)
        ,(0x787c09494ec8bcb24dcaf8659e7d5d69979ee508, 'MAV', 18)
        ,(0xfc7e56298657b002b3e656400e746b7212912757, 'zkUSD', 6)
        ,(0xbbeb516fb02a01611cbbe0453fe3c580d7281011, 'WBTC', 8)
        ,(0x5f7cbcb391d33988dad74d6fd683aadda1123e4d, 'RF', 18)
        ,(0x22d8b71599e14f20a49a397b88c1c878c86f5579, 'eETH', 8)
        ,(0x16a9494e257703797d747540f01683952547ee5b, 'iZi', 18)
        ,(0x85d84c774cf8e9ff85342684b0e795df72a24908, 'VC', 18)
        ,(0x503234f203fc7eb888eec8513210612a43cf6115, 'LUSD', 18)
        ,(0xc5db68f30d21cbe0c9eac7be5ea83468d69297e6, 'rfETH', 18)
        ,(0x1181d7be04d80a8ae096641ee1a87f7d557c6aeb, 'nUSDC', 8)
     ) AS temp_table (contract_address, symbol, decimals)
