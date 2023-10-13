package model

type (
	// CyberLink represents cyber_link
	CyberLink struct {
		ParticleFrom    string // Index field
		ParticleTo      string // Index field
		Neuron          string // Index field
		Timestamp       string //
		TransactionHash string //
		Height          int64  //
	}

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
