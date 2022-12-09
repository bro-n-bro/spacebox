package model

type CommunityPool struct {
	Coins  Coins `json:"coins"`
	Height int64 `json:"height"`
}
