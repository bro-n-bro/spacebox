package model

type FeeAllowance struct {
	Granter   string `json:"granter"`
	Grantee   string `json:"grantee"`
	Allowance []byte `json:"allowance"`
}
