package model

import "time"

type Proposal struct {
	ID              uint64    `json:"id"`
	Title           string    `json:"title"`
	Description     string    `json:"description"`
	ProposalRoute   string    `json:"proposal_route"`
	ProposalType    string    `json:"proposal_type"`
	ProposerAddress string    `json:"proposer_address"`
	Status          string    `json:"status"`
	Content         []byte    `json:"content"`
	SubmitTime      time.Time `json:"submit_time"`
	DepositEndTime  time.Time `json:"deposit_end_time"`
	VotingStartTime time.Time `json:"voting_start_time"`
	VotingEndTime   time.Time `json:"voting_end_time"`
}
