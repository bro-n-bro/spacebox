package model

type Swap struct {
	Height                    int64   `json:"height"`
	MsgIndex                  uint32  `json:"msg_index"`
	BatchIndex                uint32  `json:"batch_index"`
	PoolID                    uint32  `json:"pool_id"`
	SwapRequester             string  `json:"swap_requester"`
	OfferCoinDenom            string  `json:"offer_coin_denom"`
	OfferCoinAmount           float64 `json:"offer_coin_amount"`
	DemandCoinDenom           string  `json:"demand_coin_denom"`
	ExchangedDemandCoinAmount float64 `json:"exchanged_demand_coin_amount"`
	TransactedCoinAmount      float64 `json:"transacted_coin_amount"`
	RemainingOfferCoinAmount  float64 `json:"remaining_offer_coin_amount"`
	OfferCoinFeeAmount        float64 `json:"offer_coin_fee_amount"`
	OrderExpiryHeight         float64 `json:"order_expiry_height"`
	ExchangedCoinFeeAmount    float64 `json:"exchanged_coin_fee_amount"`
	OrderPrice                float64 `json:"order_price"`
	SwapPrice                 float64 `json:"swap_price"`
	Success                   bool    `json:"success"`
}
