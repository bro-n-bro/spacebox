package model

type SubmitProposalMessage struct {
	Height         int    `json:"height"`
	TxHash         string `json:"tx_hash"`
	MsgIndex       int    `json:"msg_index"`
	Proposer       string `json:"proposer"`
	Messages       string `json:"messages"`
	InitialDeposit int    `json:"initial_deposit"`
	Metadata       string `json:"metadata"`
	Title          string `json:"title"`
	Summary        string `json:"summary"`
}
