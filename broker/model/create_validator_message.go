package model

type CreateValidatorMessage struct {
	Height            int64                             `json:"height"`
	TxHash            string                            `json:"tx_hash"`
	MsgIndex          int64                             `json:"msg_index"`
	DelegatorAddress  string                            `json:"delegator_address"`
	ValidatorAddress  string                            `json:"validator_address"`
	Description       CreateValidatorMessageDescription `json:"description"`
	CommissionRates   float64                           `json:"commission_rates"`
	MinSelfDelegation int64                             `json:"min_self_delegation"`
	Pubkey            string                            `json:"pubkey"`
}

type CreateValidatorMessageDescription struct {
	Moniker         string `json:"moniker,omitempty"`
	Identity        string `json:"identity,omitempty"`
	Website         string `json:"website,omitempty"`
	SecurityContact string `json:"security_contact,omitempty"`
	Details         string `json:"details,omitempty"`
}
