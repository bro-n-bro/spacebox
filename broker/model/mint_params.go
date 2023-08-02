package model

type (
	MParams struct {
		MintDenom           string  `json:"mint_denom"`
		InflationRateChange float64 `json:"inflation_rate_change"`
		InflationMax        float64 `json:"inflation_max"`
		InflationMin        float64 `json:"inflation_min"`
		GoalBonded          float64 `json:"goal_bonded"`
		BlocksPerYear       uint64  `json:"blocks_per_year"`
	}

	MintParams struct {
		Height int64   `json:"height"`
		Params MParams `json:"params"`
	}
)
