package model

import "time"

type Block struct {
	Height          int64     `json:"height"`
	Hash            string    `json:"hash"`
	TxNum           int       `json:"tx_num"`
	TotalGas        uint64    `json:"total_gas"`
	ProposerAddress string    `json:"proposer_address"`
	Timestamp       time.Time `json:"timestamp"`
}

func NewBlock(height int64, hash, proposerAddress string, txNum int, totalGas uint64, timestamp time.Time) Block {
	return Block{
		Height:          height,
		Hash:            hash,
		TxNum:           txNum,
		TotalGas:        totalGas,
		ProposerAddress: proposerAddress,
		Timestamp:       timestamp,
	}
}
