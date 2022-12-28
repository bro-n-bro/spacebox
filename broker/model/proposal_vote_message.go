package model

type ProposalVoteMessage struct {
	ProposalID uint64 `json:"proposal_id"`
	Voter      string `json:"voter"`
	Option     string `json:"option"`
	Height     int64  `json:"height"`
}

func NewProposalVoteMessage(proposalID uint64, height int64, voter, option string) ProposalVoteMessage {
	return ProposalVoteMessage{
		ProposalID: proposalID,
		Voter:      voter,
		Option:     option,
		Height:     height,
	}
}
