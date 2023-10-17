package model

type (
	GovParams struct {
		DepositParams DepositParams `json:"deposit_params"` //
		VotingParams  VotingParams  `json:"voting_params"`  //
		TallyParams   TallyParams   `json:"tally_params"`   //
		Height        int64         `json:"height"`         //
	}

	// VotingParams contains the voting parameters of the x/gov module
	VotingParams struct {
		VotingPeriod int64 `json:"voting_period,omitempty"` //
	}

	// DepositParams contains the data of the deposit parameters of the x/gov module
	DepositParams struct {
		MinDeposit       Coins `json:"min_deposit,omitempty"`        //
		MaxDepositPeriod int64 `json:"max_deposit_period,omitempty"` //
	}

	// TallyParams contains the tally parameters of the x/gov module
	TallyParams struct {
		Quorum        float64 `json:"quorum,omitempty"`         //
		Threshold     float64 `json:"threshold,omitempty"`      //
		VetoThreshold float64 `json:"veto_threshold,omitempty"` //
	}
)
