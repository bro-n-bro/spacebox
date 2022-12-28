package model

type MultiSendMessage struct {
	Coins       Coins  `json:"coins"`
	AddressFrom string `json:"address_from"`
	AddressTo   string `json:"address_to"`
	TxHash      string `json:"tx_hash"`
	Height      int64  `json:"height"`
}

func NewMultiSendMessage(height int64, addressFrom, addressTo, txHash string, coins Coins) MultiSendMessage {
	return MultiSendMessage{
		Coins:       coins,
		AddressFrom: addressFrom,
		AddressTo:   addressTo,
		TxHash:      txHash,
		Height:      height,
	}
}
