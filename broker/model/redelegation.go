package model

import (
	"time"
)

type (
	Redelegation struct {
		CompletionTime      time.Time `json:"completion_time"`       //
		Coin                Coin      `json:"coin"`                  //
		DelegatorAddress    string    `json:"delegator_address"`     //
		SrcValidatorAddress string    `json:"src_validator_address"` //
		DstValidatorAddress string    `json:"dst_validator_address"` //
		Height              int64     `json:"height"`                //
	}

	RedelegationMessage struct {
		Redelegation
		TxHash   string `json:"tx_hash"`   //
		MsgIndex int64  `json:"msg_index"` //
	}
)
