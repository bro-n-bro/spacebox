package model

type MultiSendMessage struct {
	Coins       Coins  `json:"coins"`
	AddressFrom string `json:"address_from"`
	AddressTo   string `json:"address_to"`
	TxHash      string `json:"tx_hash"`
	Height      int64  `json:"height"`
}
