package model

type ProposalVoteMessage struct {
	ProposalID uint64 `json:"proposal_id"`
	Voter      string `json:"voter"`
	Option     string `json:"option"`
	Height     int64  `json:"height"`
	MsgIndex   int64  `json:"msg_index"`
}

func NewProposalVoteMessage(proposalID uint64, height, msgIndex int64, voter, option string) ProposalVoteMessage {
	return ProposalVoteMessage{
		ProposalID: proposalID,
		Voter:      voter,
		Option:     option,
		Height:     height,
		MsgIndex:   msgIndex,
	}
}
