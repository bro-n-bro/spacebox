package model

import (
	"time"
)

type (
	SlashingParams struct {
		Height int64             `json:"height"` //
		Params RawSlashingParams `json:"params"` //
	}

	RawSlashingParams struct {
		DowntimeJailDuration    time.Duration `json:"downtime_jail_duration"`     //
		SignedBlocksWindow      int64         `json:"signed_blocks_window"`       //
		MinSignedPerWindow      float64       `json:"min_signed_per_window"`      //
		SlashFractionDoubleSign float64       `json:"slash_fraction_double_sign"` //
		SlashFractionDowntime   float64       `json:"slash_fraction_downtime"`    //
	}
)
