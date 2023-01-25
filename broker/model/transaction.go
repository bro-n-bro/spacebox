package model

type (
	Fee struct {
		Coins    Coins  `json:"coins"`
		GasLimit uint64 `json:"gas_limit"`
		Payer    string `json:"payer"`
		Granter  string `json:"granter"`
	}

	SignersInfo struct {
		PublicKey string `json:"public_key"`
		Sequence  uint64 `json:"sequence"`
		// TODO: ModeInfo
	}

	Transaction struct {
		Hash        string        `json:"hash"`
		Height      int64         `json:"height"`
		Success     bool          `json:"success"`
		Messages    [][]byte      `json:"messages"`
		Memo        string        `json:"memo"`
		Signatures  []string      `json:"signatures"`
		Signer      string        `json:"signer"`
		GasWanted   int64         `json:"gas_wanted"`
		GasUsed     int64         `json:"gas_used"`
		RawLog      string        `json:"raw_log"`
		Logs        []byte        `json:"logs"`
		SignerInfos []SignersInfo `json:"signer_infos"`
		Fee         *Fee          `json:"fee,omitempty"`
	}
)
