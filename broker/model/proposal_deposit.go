package model

type ProposalDeposit struct {
	ProposalID       uint64 `json:"proposal_id"`
	DepositorAddress string `json:"depositor_address"`
	Coins            Coins  `json:"coins"`
	Height           int64  `json:"height"`
}

func NewProposalDeposit(proposalID uint64, height int64, depositorAddress string, coins Coins) ProposalDeposit {
	return ProposalDeposit{
		ProposalID:       proposalID,
		DepositorAddress: depositorAddress,
		Coins:            coins,
		Height:           height,
	}
}
