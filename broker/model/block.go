package model

import "time"

type Block struct {
	Height          int64     `json:"height"`
	Hash            string    `json:"hash"`
	NumTxs          int       `json:"num_txs"`
	TotalGas        uint64    `json:"total_gas"`
	ProposerAddress string    `json:"proposer_address"`
	Timestamp       time.Time `json:"timestamp"`
}

func NewBlock(height int64, hash, proposerAddress string, numTxs int, totalGas uint64, timestamp time.Time) Block {
	return Block{
		Height:          height,
		Hash:            hash,
		NumTxs:          numTxs,
		TotalGas:        totalGas,
		ProposerAddress: proposerAddress,
		Timestamp:       timestamp,
	}
}
