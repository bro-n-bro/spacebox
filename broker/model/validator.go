package model

type (
	Validator struct {
		ConsensusAddress string `json:"consensus_address"` //
		OperatorAddress  string `json:"operator_address"`  //
		ConsensusPubkey  string `json:"consensus_pubkey"`  //
		Height           int64  `json:"height"`            //
	}
)
