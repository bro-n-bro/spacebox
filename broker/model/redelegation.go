package model

import "time"

type Redelegation struct {
	CompletionTime   time.Time `json:"completion_time"`
	Coin             Coin      `json:"coin"`
	DelegatorAddress string    `json:"delegator_address"`
	SrcValidator     string    `json:"src_validator"`
	DstValidator     string    `json:"dst_validator"`
	Height           int64     `json:"height"`
}
