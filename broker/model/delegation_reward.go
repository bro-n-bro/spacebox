package model

type DelegationReward struct {
	Height           int64  `json:"height"`
	OperatorAddress  string `json:"operator_address"`
	DelegatorAddress string `json:"delegator_address"`
	WithdrawAddress  string `json:"withdraw_address"`
	Coins            Coins  `json:"coins"`
}

func NewDelegationReward(height int64, operatorAddress, delegatorAddress, withdrawAddress string,
	coins Coins) DelegationReward {

	return DelegationReward{
		Height:           height,
		OperatorAddress:  operatorAddress,
		DelegatorAddress: delegatorAddress,
		WithdrawAddress:  withdrawAddress,
		Coins:            coins,
	}
}
