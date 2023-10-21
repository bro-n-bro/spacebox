package model

type (
	Route struct {
		Source      string `json:"source"`      //
		Destination string `json:"destination"` //
		Alias       string `json:"alias"`       //
		Timestamp   string `json:"timestamp"`   //
		TxHash      string `json:"tx_hash"`     //
		Value       Coin   `json:"value"`       //
		Height      int64  `json:"height"`      //
		IsActive    bool   `json:"is_active"`   //
	}

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
