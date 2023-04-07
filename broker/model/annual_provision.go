package model

type AnnualProvision struct {
	Height          int64   `json:"height"`
	Amount          int64   `json:"amount"`
	AnnualProvision float64 `json:"annual_provision"`
	BondedRatio     float64 `json:"bonded_ratio"`
	Inflation       float64 `json:"inflation"`
}
