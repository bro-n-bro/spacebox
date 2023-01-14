package model

type MultiSendMessage struct {
	Coins       Coins    `json:"coins"`
	AddressFrom string   `json:"address_from"`
	AddressesTo []string `json:"address_to"`
	TxHash      string   `json:"tx_hash"`
	Height      int64    `json:"height"`
	MsgIndex    int64    `json:"msg_index"`
}

func NewMultiSendMessage(
	addressesTo []string,
	addressFrom, txHash string,
	height, msgIndex int64,
	coins Coins,
) MultiSendMessage {
	return MultiSendMessage{
		Coins:       coins,
		AddressFrom: addressFrom,
		AddressesTo: addressesTo,
		TxHash:      txHash,
		Height:      height,
		MsgIndex:    msgIndex,
	}
}
