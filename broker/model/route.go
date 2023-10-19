package model

type (
	CreateRouteMessage struct {
		Source      string `json:"source"`      //
		Destination string `json:"destination"` //
		Name        string `json:"name"`        //
		TxHash      string `json:"tx_hash"`     //
		Height      int64  `json:"height"`      //
		MsgIndex    int64  `json:"msg_index"`   //
	}

	EditRouteMessage struct {
		Source      string `json:"source"`      //
		Destination string `json:"destination"` //
		Value       Coin   `json:"value"`       //
		TxHash      string `json:"tx_hash"`     //
		Height      int64  `json:"height"`      //
		MsgIndex    int64  `json:"msg_index"`   //
	}

	EditRouteNameMessage struct {
		Source      string `json:"source"`      //
		Destination string `json:"destination"` //
		Name        string `json:"name"`        //
		TxHash      string `json:"tx_hash"`     //
		Height      int64  `json:"height"`      //
		MsgIndex    int64  `json:"msg_index"`   //
	}

	DeleteRouteMessage struct {
		Source      string `json:"source"`      //
		Destination string `json:"destination"` //
		TxHash      string `json:"tx_hash"`     //
		Height      int64  `json:"height"`      //
		MsgIndex    int64  `json:"msg_index"`   //
	}
)
