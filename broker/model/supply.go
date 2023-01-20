package model

type Supply struct {
	Height int64 `json:"height"`
	Coins  Coins `json:"coins"`
}
