package model

import "time"

type (
	AuthzGrant struct {
		Height         int64     `json:"height"`
		GranterAddress string    `json:"granter_address"`
		GranteeAddress string    `json:"grantee_address"`
		MsgType        string    `json:"msg_type"`
		Expiration     time.Time `json:"expiration"`
	}

	ExecMessage struct {
		Height   int64    `json:"height"`
		MsgIndex int64    `json:"msg_index"`
		TxHash   string   `json:"tx_hash"`
		Grantee  string   `json:"grantee"`
		Msgs     [][]byte `json:"msgs"`
	}

	GrantMessage struct {
		Height     int64     `json:"height"`
		MsgIndex   int64     `json:"msg_index"`
		TxHash     string    `json:"tx_hash"`
		Granter    string    `json:"granter"`
		Grantee    string    `json:"grantee"`
		MsgType    string    `json:"msg_type"`
		Expiration time.Time `json:"expiration"`
	}

	RevokeMessage struct {
		Height   int64  `json:"height"`
		MsgIndex int64  `json:"msg_index"`
		TxHash   string `json:"tx_hash"`
		Granter  string `json:"granter"`
		Grantee  string `json:"grantee"`
		MsgType  string `json:"msg_type"`
	}
)
