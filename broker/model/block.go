package model

import "time"

type Block struct {
	Height          int64     `json:"height"`
	Hash            string    `json:"hash"`
	TxNum           int64     `json:"tx_num"`
	TotalGas        uint64    `json:"total_gas"`
	ProposerAddress string    `json:"proposer_address"`
	Timestamp       time.Time `json:"timestamp"`
}
