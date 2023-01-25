package model

type (
	VDescription struct {
		Moniker         string `json:"moniker"`
		Identity        string `json:"identity"`
		Website         string `json:"website"`
		SecurityContact string `json:"security_contact"`
		Details         string `json:"details"`
	}
	ValidatorDescription struct {
		OperatorAddress string
		Description     VDescription
		AvatarURL       string
		Height          int64
	}
)
