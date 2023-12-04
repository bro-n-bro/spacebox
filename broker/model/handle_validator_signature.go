package model

type (
	HandleValidatorSignature struct {
		OperatorAddress string `json:"operator_address"` //
		Power           string `json:"power"`            //
		Reason          string `json:"reason"`           //
		Jailed          string `json:"jailed"`           //
		Burned          Coin   `json:"burned"`           //
		Height          int64  `json:"height"`           //
	}
)
