package model

type Delegation struct {
	OperatorAddress  string `json:"operator_address"`
	DelegatorAddress string `json:"delegator_address"`
	Coin             Coin   `json:"coin"`
	Height           int64  `json:"height"`
}
