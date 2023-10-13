package model

type (
	AccountBalance struct {
		Address string `json:"address"` //
		Height  int64  `json:"height"`  //
		Coins   Coins  `json:"coins"`   //
	}
)
