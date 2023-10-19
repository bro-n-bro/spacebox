package model

type (
	// InvestmintMessage represents investmint message
	InvestmintMessage struct {
		Height   int64  `json:"height"`    //
		MsgIndex int64  `json:"msg_index"` //
		TxHash   string `json:"tx_hash"`   //
		Neuron   string `json:"neuron"`    //
		Amount   Coin   `json:"amount"`    //
		Resource string `json:"resource"`  //
		Length   uint64 `json:"length"`    //
	}
)
