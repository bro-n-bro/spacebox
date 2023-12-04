package model

type (
	Coin struct {
		Denom  string  `json:"denom"`  //
		Amount float64 `json:"amount"` //
	}

	Coins []Coin
)
