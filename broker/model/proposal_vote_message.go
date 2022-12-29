package model

type ProposalVoteMessage struct {
	ProposalID   uint64 `json:"proposal_id"`
	VoterAddress string `json:"voter"`
	Option       string `json:"option"`
	Height       int64  `json:"height"`
}

func NewProposalVoteMessage(proposalID uint64, height int64, voterAddress, option string) ProposalVoteMessage {
	return ProposalVoteMessage{
		ProposalID:   proposalID,
		VoterAddress: voterAddress,
		Option:       option,
		Height:       height,
	}
}
