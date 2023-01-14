package model

type Validator struct {
	ConsensusAddress string `json:"consensus_address"`
	OperatorAddress  string `json:"operator_address"`
	ConsensusPubkey  string `json:"consensus_pubkey"`
}

func NewValidator(consensusAddress, consensusPubkey, operatorAddress string) Validator {
	return Validator{
		ConsensusAddress: consensusAddress,
		OperatorAddress:  operatorAddress,
		ConsensusPubkey:  consensusPubkey,
	}
}
