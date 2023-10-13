package model

type (
	CancelUnbondingDelegationMessage struct {
		Height           int64  `json:"height"`            //
		TxHash           string `json:"tx_hash"`           //
		MsgIndex         int64  `json:"msg_index"`         //
		ValidatorAddress string `json:"validator_address"` //
		DelegatorAddress string `json:"delegator_address"` //
	}
)
