package model

type WithdrawValidatorCommissionMessage struct {
	Height             int64  `json:"height"`
	TxHash             string `json:"tx_hash"`
	MsgIndex           int64  `json:"msg_index"`
	WithdrawCommission int64  `json:"withdraw_commission"`
	ValidatorAddress   string `json:"validator_address"`
}