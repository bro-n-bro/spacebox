package model

type (
	// Cyberlink represents cyber_link
	Cyberlink struct {
		ParticleFrom string `json:"particle_from"` //
		ParticleTo   string `json:"particle_to"`   //
		Neuron       string `json:"neuron"`        //
		Timestamp    string `json:"timestamp"`     //
		TxHash       string `json:"tx_hash"`       //
		Height       int64  `json:"height"`        //
	}
)
