package model

type Validator struct {
	ConsensusAddress string `json:"consensus_address"`
	ConsensusPubkey  string `json:"consensus_pubkey"`
}

func NewValidator(consensusAddress, consensusPubkey string) Validator {
	return Validator{
		ConsensusAddress: consensusAddress,
		ConsensusPubkey:  consensusPubkey,
	}
}
