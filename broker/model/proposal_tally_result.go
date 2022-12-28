package model

type ProposalTallyResult struct {
	ProposalID uint64 `json:"proposal_id"`
	Yes        int64  `json:"yes"`
	No         int64  `json:"no"`
	Abstain    int64  `json:"abstain"`
	NoWithVeto int64  `json:"no_with_veto"`
	Height     int64  `json:"height"`
}

func NewProposalTallyResult(proposalID uint64, height, yes, abstain, no, noWithVeto int64) ProposalTallyResult {
	return ProposalTallyResult{
		ProposalID: proposalID,
		Yes:        yes,
		No:         no,
		Abstain:    abstain,
		NoWithVeto: noWithVeto,
		Height:     height,
	}
}
