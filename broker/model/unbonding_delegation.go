package model

import "time"

type (
	UnbondingDelegation struct {
		CompletionTimestamp time.Time `json:"completion_timestamp"`
		Coin                Coin      `json:"coin"`
		DelegatorAddress    string    `json:"delegator_address"`
		ValidatorOperAddr   string    `json:"validator_oper_addr"`
		TxHash              string    `json:"tx_hash"`
		Height              int64     `json:"height"`
	}

	UnbondingDelegationMessage struct {
		UnbondingDelegation
		TxHash string `json:"tx_hash"`
	}
)
