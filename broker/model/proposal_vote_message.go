package model

type ProposalVoteMessage struct {
	ProposalID   uint64 `json:"proposal_id"`
	VoterAddress string `json:"voter"`
	Option       string `json:"option"`
	Height       int64  `json:"height"`
	MsgIndex     int64  `json:"msg_index"`
}
