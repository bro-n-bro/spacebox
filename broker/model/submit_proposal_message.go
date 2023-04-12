package model

type SubmitProposalMessage struct {
	Height         int64  `json:"height"`
	TxHash         string `json:"tx_hash"`
	MsgIndex       int64  `json:"msg_index"`
	Proposer       string `json:"proposer"`
	Messages       string `json:"messages"`
	InitialDeposit int64  `json:"initial_deposit"`
	Title          string `json:"title"`
	Description    string `json:"description"`
	Type           string `json:"type"`
	ProposalID     uint64 `json:"proposal_id"`
}
