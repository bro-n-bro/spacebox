package model

import "time"

type ValidatorPrecommit struct {
	Height           int64     `json:"height"`
	ValidatorAddress string    `json:"validator_address"`
	VotingPower      int64     `json:"voting_power"`
	BlockIDFlag      uint64    `json:"block_id_flag"`
	Timestamp        time.Time `json:"timestamp"`
}
