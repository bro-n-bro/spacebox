package model

type (
	WithdrawValidatorCommissionMessage struct {
		Height             int64  `json:"height"`              //
		TxHash             string `json:"tx_hash"`             //
		MsgIndex           int64  `json:"msg_index"`           //
		WithdrawCommission Coins  `json:"withdraw_commission"` //
		OperatorAddress    string `json:"operator_address"`    //
	}
)
