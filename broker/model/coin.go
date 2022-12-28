package model

type Coins []Coin

type Coin struct {
	Denom  string  `json:"denom"`
	Amount float64 `json:"amount"`
}

func NewCoin(denom string, amount float64) Coin {
	return Coin{
		Denom:  denom,
		Amount: amount,
	}
}
