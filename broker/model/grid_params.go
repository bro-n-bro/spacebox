package model

type (
	// GridParams represents GParams with Height
	GridParams struct {
		Height int64   `json:"height"` //
		Params GParams `json:"params"` //
	}

	// GParams represents grid_params
	GParams struct {
		MaxRoutes int64 `json:"max_routes"`
	}
)
