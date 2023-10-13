package model

import (
	"time"
)

type (
	Block struct {
		Height          int64     `json:"height"`           //
		Hash            string    `json:"hash"`             //
		NumTxs          int64     `json:"num_txs"`          //
		TotalGas        uint64    `json:"total_gas"`        //
		ProposerAddress string    `json:"proposer_address"` //
		Timestamp       time.Time `json:"timestamp"`        //
	}
)
