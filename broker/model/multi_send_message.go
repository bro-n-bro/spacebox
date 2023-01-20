package model

type MultiSendMessage struct {
	Coins       Coins    `json:"coins"`
	AddressFrom string   `json:"address_from"`
	AddressesTo []string `json:"address_to"`
	TxHash      string   `json:"tx_hash"`
	Height      int64    `json:"height"`
	MsgIndex    int64    `json:"msg_index"`
}
