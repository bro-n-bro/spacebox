package model

type ProposalVoteMessage struct {
	ProposalID uint64 `json:"proposal_id"`
	Voter      string `json:"voter"`
	Option     string `json:"option"`
	Height     int64  `json:"height"`
}
