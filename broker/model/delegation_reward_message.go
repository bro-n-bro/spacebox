package model

type (
	DelegationRewardMessage struct {
		Coins            Coins  `json:"coins"`             //
		Height           int64  `json:"height"`            //
		DelegatorAddress string `json:"delegator_address"` //
		OperatorAddress  string `json:"operator_address"`  //
		TxHash           string `json:"tx_hash"`           //
		MsgIndex         int64  `json:"msg_index"`         //
	}
)
