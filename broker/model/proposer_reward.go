package model

type ProposerReward struct {
	Height    int64  `json:"height"`
	Validator string `json:"validator"`
	Reward    Coin   `json:"reward"`
}
