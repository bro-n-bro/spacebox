package model

type (
	Delegation struct {
		OperatorAddress  string `json:"operator_address"`
		DelegatorAddress string `json:"delegator_address"`
		Coin             Coin   `json:"coin"`
		Height           int64  `json:"height"`
	}
	DelegationMessage struct {
		Delegation
		TxHash string `json:"tx_hash"`
	}
)

func NewDelegation(operatorAddress, delegatorAddress string, height int64, coin Coin) Delegation {
	return Delegation{
		OperatorAddress:  operatorAddress,
		DelegatorAddress: delegatorAddress,
		Coin:             coin,
		Height:           height,
	}
}

func NewDelegationMessage(operatorAddress, delegatorAddress, txHash string, height int64, coin Coin) DelegationMessage {
	return DelegationMessage{
		Delegation: Delegation{
			OperatorAddress:  operatorAddress,
			DelegatorAddress: delegatorAddress,
			Coin:             coin,
			Height:           height,
		},
		TxHash: txHash,
	}
}
