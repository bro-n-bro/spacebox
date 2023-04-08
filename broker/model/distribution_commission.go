package model

type DistributionCommission struct {
	Height     int64  `json:"height"`
	Validator  string `json:"validator"`
	Commission Coin   `json:"commission"`
}
