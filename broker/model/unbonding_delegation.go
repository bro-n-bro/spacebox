package model

import (
	"time"
)

type (
	UnbondingDelegation struct {
		CompletionTime   time.Time `json:"completion_time"`   //
		Coin             Coin      `json:"coin"`              //
		DelegatorAddress string    `json:"delegator_address"` //
		OperatorAddress  string    `json:"operator_address"`  //
		Height           int64     `json:"height"`            //
	}

	UnbondingDelegationMessage struct {
		UnbondingDelegation
		TxHash   string `json:"tx_hash"`   //
		MsgIndex int64  `json:"msg_index"` //
	}
)
