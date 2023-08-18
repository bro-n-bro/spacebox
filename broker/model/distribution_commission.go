package model

type DistributionCommission struct {
	Height          int64  `json:"height"`
	OperatorAddress string `json:"operator_address"`
	Amount          Coin   `json:"amount"`
}
