package model

type SubmitProposalMessage struct {
	Height         int    `json:"height"`
	TxHash         string `json:"txHash"`
	MsgIndex       int    `json:"msgIndex"`
	Proposer       string `json:"proposer"`
	Messages       string `json:"messages"`
	InitialDeposit int    `json:"initialDeposit"`
	Metadata       string `json:"metadata"`
	Title          string `json:"title"`
	Summary        string `json:"summary"`
}
