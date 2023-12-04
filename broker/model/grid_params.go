package model

type (
	// GridParams represents RawGridParams with Height
	GridParams struct {
		Height int64         `json:"height"` //
		Params RawGridParams `json:"params"` //
	}

	// RawGridParams represents grid_params
	RawGridParams struct {
		MaxRoutes int64 `json:"max_routes"` //
	}
)
