package model

type UnjailMessage struct {
	Height          int64  `json:"height"`
	Hash            string `json:"tx_hash"`
	Index           int64  `json:"msg_index"`
	OperatorAddress string `json:"operator_address"`
}
