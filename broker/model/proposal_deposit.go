package model

type ProposalDeposit struct {
	ProposalID       uint64 `json:"proposal_id"`
	DepositorAddress string `json:"depositor_address"`
	Coins            Coins  `json:"coins"`
	Height           int64  `json:"height"`
}
