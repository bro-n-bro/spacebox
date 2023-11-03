package model

type (
	// CyberlinkMessage represents cyber_link message
	CyberlinkMessage struct {
		TxHash       string `json:"tx_hash"`       //
		Neuron       string `json:"neuron"`        //
		ParticleFrom string `json:"particle_from"` //
		ParticleTo   string `json:"particle_to"`   //
		Height       int64  `json:"height"`        //
		MsgIndex     int64  `json:"msg_index"`     //
		LinkIndex    int64  `json:"link_index"`    //
	}
)
