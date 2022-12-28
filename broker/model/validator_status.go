package model

type ValidatorStatus struct {
	Height           int64  `json:"height"`
	ValidatorAddress string `json:"validator_address"`
	Status           int64  `json:"status"`
	Jailed           bool   `json:"jailed"`
}

func NewValidatorStatus(height, status int64, validatorAddress string, jailed bool) ValidatorStatus {
	return ValidatorStatus{
		Height:           height,
		ValidatorAddress: validatorAddress,
		Status:           status,
		Jailed:           jailed,
	}
}
