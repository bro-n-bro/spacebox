package model

type Coins []Coin

type Coin struct {
	Denom  string  `json:"denom"`
	Amount float64 `json:"amount"`
}
