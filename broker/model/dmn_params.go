package model

type (
	// DMNParams represents DMParams with Height
	DMNParams struct {
		Height int64    `json:"height"` //
		Params DMParams `json:"params"` //
	}

	// DMParams represents dmn_params
	DMParams struct {
		MaxSlots int64 `json:"max_slots"`
		MaxGas   int64 `json:"max_gas"`
		FeeTTL   int64 `json:"fee_ttl"`
	}
)
