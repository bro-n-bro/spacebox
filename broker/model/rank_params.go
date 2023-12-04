package model

type (
	// RankParams represents RParams with Height
	RankParams struct {
		Height int64         `json:"height"` //
		Params RawRankParams `json:"params"` //
	}

	// RawRankParams represents rank_params
	RawRankParams struct {
		CalculationPeriod int64   `json:"calculation_period"`
		DampingFactor     float64 `json:"damping_factor"`
		Tolerance         float64 `json:"tolerance"`
	}
)
