package model

type SendMessage struct {
	Coins       Coins  `json:"coins"`
	AddressFrom string `json:"address_from"`
	AddressTo   string `json:"address_to"`
	TxHash      string `json:"tx_hash"`
	Height      int64  `json:"height"`
}

func NewSendMessage(height int64, addressFrom, addressTo, txHash string, coins Coins) SendMessage {
	return SendMessage{
		Coins:       coins,
		AddressFrom: addressFrom,
		AddressTo:   addressTo,
		TxHash:      txHash,
		Height:      height,
	}
}
