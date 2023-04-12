package model

type WeightedVoteOption struct {
	Option int32   `json:"option,omitempty"`
	Weight float64 `json:"weight"`
}
