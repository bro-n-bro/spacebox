package model

type AnnualProvision struct {
	Height           int64   `json:"height"`
	Amount           int64   `json:"amount"`
	AnnualProvisions float64 `json:"annual_provisions"`
	BondedRatio      float64 `json:"bonded_ratio"`
	Inflation        float64 `json:"inflation"`
}
