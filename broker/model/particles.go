package model

type (
	// Particle represents a particle
	Particle struct {
		Particle  string `json:"particle"`  //
		Neuron    string `json:"neuron"`    //
		Timestamp string `json:"timestamp"` //
		TxHash    string `json:"tx_hash"`   //
		Height    int64  `json:"height"`    //
	}
)
