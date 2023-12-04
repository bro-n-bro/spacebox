package model

type (
	// DMNParams represents RawDMNParams with Height
	DMNParams struct {
		Height int64        `json:"height"` //
		Params RawDMNParams `json:"params"` //
	}

	// RawDMNParams represents dmn_params
	RawDMNParams struct {
		MaxSlots int64 `json:"max_slots"`
		MaxGas   int64 `json:"max_gas"`
		FeeTTL   int64 `json:"fee_ttl"`
	}
)
