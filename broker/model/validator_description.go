package model

type (
	ValidatorDescription struct {
		OperatorAddress string `json:"operator_address"`
		Moniker         string `json:"moniker"`
		Identity        string `json:"identity"`
		Website         string `json:"website"`
		SecurityContact string `json:"security_contact"`
		Details         string `json:"details"`
		AvatarURL       string `json:"avatar_url"`
		Height          int64  `json:"height"`
	}
)
