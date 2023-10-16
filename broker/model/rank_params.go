package model

type (
	// RankParams represents RParams with Height
	RankParams struct {
		Height int64   `json:"height"` //
		Params RParams `json:"params"` //
	}

	// RParams represents rank_params
	RParams struct {
		CalculationPeriod int64   `json:"calculation_period"`
		DampingFactor     float64 `json:"damping_factor"`
		Tolerance         float64 `json:"tolerance"`
	}
)
