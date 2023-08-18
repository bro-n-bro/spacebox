package model

type DistributionReward struct {
	Height          int64  `json:"height"`
	OperatorAddress string `json:"operator_address"`
	Amount          Coin   `json:"amount"`
}
