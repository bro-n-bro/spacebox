package model

type (
	DistributionParams struct {
		Height int64                 `json:"height"` //
		Params RawDistributionParams `json:"params"` //
	}

	RawDistributionParams struct {
		CommunityTax        float64 `json:"community_tax"`         //
		BaseProposerReward  float64 `json:"base_proposer_reward"`  //
		BonusProposerReward float64 `json:"bonus_proposer_reward"` //
		WithdrawAddrEnabled bool    `json:"withdraw_addr_enabled"` //
	}
)
