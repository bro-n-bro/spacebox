package model

type DelegationMessage struct {
	Delegation
	TxHash string `json:"tx_hash"`
}
