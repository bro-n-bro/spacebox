package model

import "time"

type FeeAllowance struct {
	Height     int64     `json:"height"`
	Granter    string    `json:"granter"`
	Grantee    string    `json:"grantee"`
	Allowance  []byte    `json:"allowance"`
	Expiration time.Time `json:"expiration"`
	IsActive   bool      `json:"is_active"`
}
