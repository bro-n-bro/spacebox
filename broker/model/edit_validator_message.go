package model

type EditValidatorMessage struct {
	Height      int64
	Hash        string
	Index       int64
	Description ValidatorMessageDescription
}
