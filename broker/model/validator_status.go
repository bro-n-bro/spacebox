package model

type ValidatorStatus struct {
	Height           int64  `json:"height"`
	ConsensusAddress string `json:"consensus_address"`
	Status           int64  `json:"status"`
	Jailed           bool   `json:"jailed"`
}
