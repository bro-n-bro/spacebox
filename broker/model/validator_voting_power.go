package model

type (
	ValidatorVotingPower struct {
		Height           int64  `json:"height"`            //
		VotingPower      int64  `json:"voting_power"`      //
		ValidatorAddress string `json:"validator_address"` //
		ProposerPriority int64  `json:"proposer_priority"` //
	}
)
