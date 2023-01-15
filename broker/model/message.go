package model

type Message struct {
	TransactionHash           string   `json:"transaction_hash"`
	Type                      string   `json:"type"`
	Signer                    string   `json:"signer"`
	InvolvedAccountsAddresses []string `json:"involved_accounts_addresses"`
	Value                     []byte   `json:"value"`
	MsgIndex                  int64    `json:"msg_index"`
	Index                     int64    `json:"index"`
}

func NewMessage(
	transactionHash, msgType, signer string,
	index, msgIndex int64,
	value []byte,
	involvedAccountsAddresses []string,
) Message {
	return Message{
		TransactionHash:           transactionHash,
		Index:                     index,
		Type:                      msgType,
		Value:                     value,
		InvolvedAccountsAddresses: involvedAccountsAddresses,
		Signer:                    signer,
		MsgIndex:                  msgIndex,
	}
}
