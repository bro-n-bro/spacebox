package model

import "time"

type ValidatorVotingPower struct {
	Height           int64     `json:"height"`
	VotingPower      int64     `json:"voting_power"`
	ValidatorAddress string    `json:"validator_address"`
	Timestamp        time.Time `json:"timestamp"`
}
