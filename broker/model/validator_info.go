package model

type ValidatorInfo struct {
	ConsensusAddress    string `json:"consensus_address"`
	OperatorAddress     string `json:"operator_address"`
	SelfDelegateAddress string `json:"self_delegate_address"`
	MinSelfDelegation   int64  `json:"min_self_delegation"`
	Height              int64  `json:"height"`
}

func NewValidatorInfo(height, minSelfDelegation int64, consensusAddress, operatorAddress,
	selfDelegateAddress string) ValidatorInfo {

	return ValidatorInfo{
		ConsensusAddress:    consensusAddress,
		OperatorAddress:     operatorAddress,
		SelfDelegateAddress: selfDelegateAddress,
		MinSelfDelegation:   minSelfDelegation,
		Height:              height,
	}
}
