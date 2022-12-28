package model

type Account struct {
	Address string `json:"address"`
	Height  int64  `json:"height"`
}

func NewAccount(address string, height int64) Account {
	return Account{
		Address: address,
		Height:  height,
	}
}
