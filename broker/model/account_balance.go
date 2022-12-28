package model

type AccountBalance struct {
	Address string `json:"address"`
	Height  int64  `json:"height"`
	Coins   Coins  `json:"coins"`
}

func NewAccountBalance(address string, height int64, coins Coins) AccountBalance {
	return AccountBalance{
		Address: address,
		Height:  height,
		Coins:   coins,
	}
}
