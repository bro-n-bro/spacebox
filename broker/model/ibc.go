package model

type (
	TransferMessage struct {
		SourceChannel string `json:"source_channel"`
		Coin          Coin   `json:"coin"`
		Sender        string `json:"sender"`
		Receiver      string `json:"receiver"`
		Height        int64  `json:"height"`
		MsgIndex      int64  `json:"msg_index"`
		TxHash        string `json:"tx_hash"`
	}

	AcknowledgementMessage struct {
		SourcePort         string `json:"source_port"`
		SourceChannel      string `json:"source_channel"`
		DestinationPort    string `json:"destination_port"`
		DestinationChannel string `json:"destination_channel"`
		Data               []byte `json:"data"`
		TimeoutTimestamp   uint64 `json:"timeout_timestamp"`
		Signer             string `json:"signer"`
		Height             int64  `json:"height"`
		MsgIndex           int64  `json:"msg_index"`
		TxHash             string `json:"tx_hash"`
	}

	RecvPacketMessage struct {
		SourcePort         string `json:"source_port"`
		SourceChannel      string `json:"source_channel"`
		DestinationPort    string `json:"destination_port"`
		DestinationChannel string `json:"destination_channel"`
		Signer             string `json:"signer"`
		Data               []byte `json:"data"`
		TimeoutTimestamp   uint64 `json:"timeout_timestamp"`
		Height             int64  `json:"height"`
		MsgIndex           int64  `json:"msg_index"`
		TxHash             string `json:"tx_hash"`
	}

	DenomTrace struct {
		DenomHash string `json:"denom_hash"`
		Path      string `json:"path"`
		BaseDenom string `json:"base_denom"`
	}
)
