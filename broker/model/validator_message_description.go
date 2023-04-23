package model

type ValidatorMessageDescription struct {
	Moniker         string `json:"moniker,omitempty"`
	Identity        string `json:"identity,omitempty"`
	Website         string `json:"website,omitempty"`
	SecurityContact string `json:"security_contact,omitempty"`
	Details         string `json:"details,omitempty"`
}
