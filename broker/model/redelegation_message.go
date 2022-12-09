package model

type RedelegationMessage struct {
	Redelegation
	TxHash string `json:"tx_hash"`
}
