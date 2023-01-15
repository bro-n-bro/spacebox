package model

import "time"

type (
	UnbondingDelegation struct {
		CompletionTimestamp time.Time `json:"completion_timestamp"`
		Coin                Coin      `json:"coin"`
		DelegatorAddress    string    `json:"delegator_address"`
		ValidatorAddress    string    `json:"validator_address"`
		Height              int64     `json:"height"`
	}

	UnbondingDelegationMessage struct {
		UnbondingDelegation
		TxHash   string `json:"tx_hash"`
		MsgIndex int64  `json:"msg_index"`
	}
)
