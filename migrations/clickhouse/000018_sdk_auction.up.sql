CREATE TABLE spacebox.sdk_auction (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `bidder` String,
    `denom` String,
    `amount` Int64,
    `transactions` Array(String)
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash,
    bidder
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.sdk_auction_writer TO spacebox.sdk_auction AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(message, 'bidder') as bidder,
	JSONExtractString(message, 'bid', 'denom') as denom,
	JSONExtractString(message, 'bid', 'amount') as amount,
	JSONExtractString(message, 'transactions') as transactions
from
(
	SELECT
		`timestamp`,
		height,
		txhash,
		message
	FROM spacebox.message
	WHERE `type` = '/sdk.auction.v1.MsgAuctionBid'
)
