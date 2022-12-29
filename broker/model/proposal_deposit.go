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
		TxHash string `json:"tx_hash"`
	}
)

func NewProposalDeposit(proposalID uint64, height int64, depositorAddress string, coins Coins) ProposalDeposit {
	return ProposalDeposit{
		ProposalID:       proposalID,
		DepositorAddress: depositorAddress,
		Coins:            coins,
		Height:           height,
	}
}

func NewProposalDepositMessage(proposalID uint64, height int64, depositorAddress, txHash string,
	coins Coins) ProposalDepositMessage {

	return ProposalDepositMessage{
		ProposalDeposit: ProposalDeposit{
			ProposalID:       proposalID,
			DepositorAddress: depositorAddress,
			Coins:            coins,
			Height:           height,
		},
		TxHash: txHash,
	}
}
