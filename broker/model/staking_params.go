package model

import "time"

type (
	sParams struct {
		UnbondingTime     time.Duration `json:"unbonding_time"`
		MaxValidators     uint32        `json:"max_validators"`
		MaxEntries        uint32        `json:"max_entries"`
		HistoricalEntries uint32        `json:"historical_entries"`
		BondDenom         string        `json:"bond_denom"`
		MinCommissionRate float64       `json:"min_commission_rate"`
	}
	StakingParams struct {
		Params sParams `json:"params"`
		Height int64   `json:"height"`
	}
)
