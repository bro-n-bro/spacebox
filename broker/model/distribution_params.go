package model

type (
	dParams struct {
		CommunityTax        float64 `json:"community_tax"`
		BaseProposerReward  float64 `json:"base_proposer_reward"`
		BonusProposerReward float64 `json:"bonus_proposer_reward"`
		WithdrawAddrEnabled bool    `json:"withdraw_addr_enabled"`
	}
	DistributionParams struct {
		Height int64   `json:"height"`
		Params dParams `json:"params"`
	}
)

func NewDistributionParams(height int64, communityTax, baseProposeReward, bonusProposerReward float64,
	withdrawAddrEnabled bool) DistributionParams {
	return DistributionParams{
		Height: height,
		Params: dParams{
			CommunityTax:        communityTax,
			BaseProposerReward:  baseProposeReward,
			BonusProposerReward: bonusProposerReward,
			WithdrawAddrEnabled: withdrawAddrEnabled,
		},
	}
}
