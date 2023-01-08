package model

type ProposalTallyResult struct {
	ProposalID uint64 `json:"proposal_id"`
	Yes        int64  `json:"yes"`
	No         int64  `json:"no"`
	Abstain    int64  `json:"abstain"`
	NoWithVeto int64  `json:"no_with_veto"`
	Height     int64  `json:"height"`
}
