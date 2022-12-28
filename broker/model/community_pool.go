package model

type CommunityPool struct {
	Coins  Coins `json:"coins"`
	Height int64 `json:"height"`
}

func NewCommunityPool(height int64, coins Coins) CommunityPool {
	return CommunityPool{
		Coins:  coins,
		Height: height,
	}
}
