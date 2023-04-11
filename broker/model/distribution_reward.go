package model

type DistributionReward struct {
	Height    int64  `json:"height"`
	Validator string `json:"validator"`
	Amount    Coin   `json:"amount"`
}
