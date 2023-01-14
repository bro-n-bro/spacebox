package model

import "time"

type (
	sParams struct {
		UnbondingTime time.Duration `json:"unbonding_time"`
		// max_validators is the maximum number of validators.
		MaxValidators uint64 `json:"max_validators"`
		// max_entries is the max entries for either unbonding delegation or redelegation (per pair/trio).
		MaxEntries uint64 `json:"max_entries"`
		// historical_entries is the number of historical entries to persist.
		HistoricalEntries uint64 `json:"historical_entries"`
		// bond_denom defines the bondable coin denomination.
		BondDenom string `json:"bond_denom"`
		// min_commission_rate is the chain-wide minimum commission rate that a validator can charge their delegators
		MinCommissionRate float64 `json:"min_commission_rate"`
	}
	StakingParams struct {
		Params sParams `json:"params"`
		Height int64   `json:"height"`
	}
)

func NewStakingParams(height int64, maxValidators, maxEntries, historicalEntries uint64, bondDenom string,
	minCommissionRate float64, unbondingTime time.Duration) StakingParams {

	return StakingParams{
		Params: sParams{
			UnbondingTime:     unbondingTime,
			MaxValidators:     maxValidators,
			MaxEntries:        maxEntries,
			HistoricalEntries: historicalEntries,
			BondDenom:         bondDenom,
			MinCommissionRate: minCommissionRate,
		},
		Height: height,
	}
}
