package model

type DistributionCommission struct {
	Height   int64  `json:"height"`
	Operator string `json:"operator"`
	Amount   Coin   `json:"amount"`
}
