package model

import (
	"time"
)

type (
	GrantAllowanceMessage struct {
		Height     int64     `json:"height"`     //
		MsgIndex   int64     `json:"msg_index"`  //
		TxHash     string    `json:"tx_hash"`    //
		Granter    string    `json:"granter"`    //
		Grantee    string    `json:"grantee"`    //
		Expiration time.Time `json:"expiration"` //
		Allowance  []byte    `json:"allowance"`  //
	}
)
