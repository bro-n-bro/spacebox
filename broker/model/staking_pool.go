package model

type (
	StakingPool struct {
		Height          int64 `json:"height"`            //
		NotBondedTokens int64 `json:"not_bonded_tokens"` //
		BondedTokens    int64 `json:"bonded_tokens"`     //
	}
)
