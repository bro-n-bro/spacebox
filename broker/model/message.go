package model

type (
	Message struct {
		TransactionHash           string   `json:"transaction_hash"`            //
		Type                      string   `json:"type"`                        //
		Signer                    string   `json:"signer"`                      //
		InvolvedAccountsAddresses []string `json:"involved_accounts_addresses"` //
		Value                     []byte   `json:"value"`                       //
		MsgIndex                  int64    `json:"msg_index"`                   //
	}
)
