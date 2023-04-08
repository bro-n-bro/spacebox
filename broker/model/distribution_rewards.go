package model

type DistributionRewards struct {
	Height    int64  `json:"height"`
	Validator string `json:"validator"`
	Rewards   Coin   `json:"rewards"`
}
