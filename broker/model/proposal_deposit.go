package model

type (
	ProposalDeposit struct {
		ProposalID       uint64 `json:"proposal_id"`
		DepositorAddress string `json:"depositor_address"`
		Coins            Coins  `json:"coins"`
		Height           int64  `json:"height"`
	}
	ProposalDepositMessage struct {
		ProposalDeposit
		TxHash   string `json:"tx_hash"`
		MsgIndex int64  `json:"msg_index"`
	}
)
