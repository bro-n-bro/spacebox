package model

type ProposerReward struct {
	Height          int64  `json:"height"`
	OperatorAddress string `json:"operator_address"`
	Reward          Coin   `json:"reward"`
}
