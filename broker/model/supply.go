package model

type Supply struct {
	Height int64 `json:"height"`
	Coins  Coins `json:"coins"`
}

func NewSupply(height int64, coins Coins) Supply {
	return Supply{
		Height: height,
		Coins:  coins,
	}
}
