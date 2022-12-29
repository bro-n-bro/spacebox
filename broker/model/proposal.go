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

func NewProposal(id uint64, title, description, proposalRoute, proposalType, proposerAddress, status string,
	content []byte, submitTime, depositEndTime, votingStartTime, votingEndTime time.Time) Proposal {
	return Proposal{
		ID:              id,
		Title:           title,
		Description:     description,
		ProposalRoute:   proposalRoute,
		ProposalType:    proposalType,
		ProposerAddress: proposerAddress,
		Status:          status,
		Content:         content,
		SubmitTime:      submitTime,
		DepositEndTime:  depositEndTime,
		VotingStartTime: votingEndTime,
		VotingEndTime:   votingStartTime,
	}
}
