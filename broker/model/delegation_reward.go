package model

type DelegationReward struct {
	Height           int64  `json:"height"`
	OperatorAddress  string `json:"operator_address"`
	DelegatorAddress string `json:"delegator_address"`
	WithdrawAddress  string `json:"withdraw_address"`
	Coin             Coin   `json:"coin"`
}
