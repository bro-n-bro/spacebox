package model

type Message struct {
	TransactionHash           string   `json:"transaction_hash"`
	Index                     int      `json:"index"`
	Type                      string   `json:"type"`
	Value                     []byte   `json:"value"`
	InvolvedAccountsAddresses []string `json:"involved_accounts_addresses"`
	Signer                    string   `json:"signer"`
	//transaction_hash            TEXT   NOT NULL REFERENCES transaction (hash),
	//index                       BIGINT NOT NULL,
	//type                        TEXT   NOT NULL,
	//value                       JSONB  NOT NULL,
	//involved_accounts_addresses TEXT[] NULL
	//signer                      TEXT   NOT NULL DEFAULT '{}'::JSONB REFERENCES accounts(address)

}
