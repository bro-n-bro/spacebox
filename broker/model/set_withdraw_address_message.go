package model

type SetWithdrawAddressMessage struct {
	Height           int64  `json:"height"`
	DelegatorAddress string `json:"delegator_address"`
	WithdrawAddress  string `json:"withdraw_address"`
	TxHash           string `json:"tx_hash"`
	MsgIndex         int64  `json:"msg_index"`
}
