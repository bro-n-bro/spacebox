package model

type HandleValidatorSignature struct {
	Address      string `json:"address"`
	Power        string `json:"power"`
	Reason       string `json:"reason"`
	Jailed       bool   `json:"jailed"`
	Burned       Coin   `json:"burned"`
	MissedBlocks int64  `json:"missed_blocks"`
	Height       int64  `json:"height"`
}
