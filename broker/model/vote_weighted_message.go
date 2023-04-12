package model

type VoteWeightedMessage struct {
	Height             int64                `json:"height"`
	TxHash             string               `json:"tx_hash"`
	MsgIndex           int64                `json:"msg_index"`
	ProposalId         uint64               `json:"proposal_id"`
	Voter              string               `json:"voter"`
	WeightedVoteOption []WeightedVoteOption `json:"weighted_vote_option"`
}
