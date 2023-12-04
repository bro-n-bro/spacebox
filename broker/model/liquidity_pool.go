package model

type (
	LiquidityPool struct {
		PoolID                uint64 `json:"pool_id"`                 //
		ReserveAccountAddress string `json:"reserve_account_address"` //
		ADenom                string `json:"a_denom"`                 //
		BDenom                string `json:"b_denom"`                 //
		PoolCoinDenom         string `json:"pool_coin_denom"`         //
		LiquidityA            Coin   `json:"liquidity_a"`             //
		LiquidityB            Coin   `json:"liquidity_b"`             //
	}
)
