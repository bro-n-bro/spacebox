package model

type CreateValidatorMessage struct {
	Height            int64                       `json:"height"`
	TxHash            string                      `json:"tx_hash"`
	MsgIndex          int64                       `json:"msg_index"`
	DelegatorAddress  string                      `json:"delegator_address"`
	ValidatorAddress  string                      `json:"validator_address"`
	Description       ValidatorMessageDescription `json:"description"`
	CommissionRates   float64                     `json:"commission_rates"`
	MinSelfDelegation int64                       `json:"min_self_delegation"`
	Pubkey            string                      `json:"pubkey"`
}
