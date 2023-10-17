package model

type (
	// CyberLinkMessage represents cyber_link message
	CyberLinkMessage struct {
		TxHash       string //
		Neuron       string //
		ParticleFrom string // `from` in links files array
		ParticleTo   string // `to` in links files array
		Height       int64  // Index field
		MsgIndex     int64  // Index field
		LinkIndex    int64  // Index field; As index in links list
	}
)
