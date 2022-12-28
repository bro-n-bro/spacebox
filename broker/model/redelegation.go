package model

import "time"

type (
	Redelegation struct {
		CompletionTime      time.Time `json:"completion_time"`
		Coin                Coin      `json:"coin"`
		DelegatorAddress    string    `json:"delegator_address"`
		SrcValidatorAddress string    `json:"src_validator_address"`
		DstValidatorAddress string    `json:"dst_validator_address"`
		Height              int64     `json:"height"`
	}
	RedelegationMessage struct {
		Redelegation
		TxHash string `json:"tx_hash"`
	}
)

func NewRedelegation(height int64, delegatorAddress, srcValidatorAddress, dstValidatorAddress string, coin Coin,
	completionTime time.Time) Redelegation {

	return Redelegation{
		CompletionTime:      completionTime,
		Coin:                coin,
		DelegatorAddress:    delegatorAddress,
		SrcValidatorAddress: srcValidatorAddress,
		DstValidatorAddress: dstValidatorAddress,
		Height:              height,
	}
}

func NewRedelegationMessage(height int64, delegatorAddress, srcValidatorAddress, dstValidatorAddress, txHash string,
	coin Coin, completionTime time.Time) RedelegationMessage {
	return RedelegationMessage{
		Redelegation: Redelegation{
			CompletionTime:      completionTime,
			Coin:                coin,
			DelegatorAddress:    delegatorAddress,
			SrcValidatorAddress: srcValidatorAddress,
			DstValidatorAddress: dstValidatorAddress,
			Height:              height,
		},
		TxHash: txHash,
	}
}
