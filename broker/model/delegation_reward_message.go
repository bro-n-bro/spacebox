package model

type DelegationRewardMessage struct {
	Coin             Coin   `json:"coin"`
	Height           int64  `json:"height"`
	DelegatorAddress string `json:"delegator_address"`
	ValidatorAddress string `json:"validator_address"`
	TxHash           string `json:"tx_hash"`
	MsgIndex         int64  `json:"msg_index"`
}
