package model

import "time"

type (
	// CyberlinkMessage represents cyberlink message
	CyberlinkMessage struct {
		ParticleFrom string    `json:"particle_from"`
		ParticleTo   string    `json:"particle_to"`
		Neuron       string    `json:"neuron"`
		Timestamp    time.Time `json:"timestamp"`
		TxHash       string    `json:"tx_hash"`
		Height       int64     `json:"height"`
		MsgIndex     int64     `json:"msg_index"`
	}
)
