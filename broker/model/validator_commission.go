package model

type ValidatorCommission struct {
	Height          int64   `json:"height"`
	OperatorAddress string  `json:"operator_address"`
	Commission      float64 `json:"commission"`
	MaxChangeRate   float64 `json:"max_change_rate"`
	MaxRate         float64 `json:"max_rate"`
}

func NewValidatorCommission(height int64, operatorAddress string, commission, maxChangeRate,
	maxRate float64) ValidatorCommission {

	return ValidatorCommission{
		Height:          height,
		OperatorAddress: operatorAddress,
		Commission:      commission,
		MaxChangeRate:   maxChangeRate,
		MaxRate:         maxRate,
	}
}
