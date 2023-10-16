package model

type (
	// BandwidthParams represents bandwidth params
	BandwidthParams struct {
		Height int64    `json:"height"` //
		Params BWParams `json:"params"` //
	}

	BWParams struct {
		RecoveryPeriod    uint64  `json:"recovery_period"`
		AdjustPricePeriod uint64  `json:"adjust_price_period"`
		BasePrice         float64 `json:"base_price"`
		BaseLoad          float64 `json:"base_load"`
		MaxBlockBandwidth uint64  `json:"max_block_bandwidth"`
	}
)
