package model

type AnnualProvision struct {
	Height          int64   `json:"height"`
	AnnualProvision float64 `json:"annual_provision"`
}

func NewAnnualProvision(height int64, annualProvision float64) AnnualProvision {
	return AnnualProvision{
		Height:          height,
		AnnualProvision: annualProvision,
	}
}
