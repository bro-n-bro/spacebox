package model

type ValidatorCommission struct {
	Height          int64   `json:"height"`
	OperatorAddress string  `json:"operator_address"`
	Commission      float64 `json:"commission"`
	MaxChangeRate   float64 `json:"max_change_rate"`
	MaxRate         float64 `json:"max_rate"`
}
