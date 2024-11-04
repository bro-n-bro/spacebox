CREATE TABLE spacebox.interchain_account (
    `timestamp` DateTime,
    `height` Int32,
    `txhash` String,
    `owner` String,
    `connection_id` String
) ENGINE = ReplacingMergeTree()
ORDER BY (
    timestamp,
    height,
    txhash
)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.interchain_account_writer TO spacebox.interchain_account AS
select
	`timestamp`,
	height,
	txhash,
	JSONExtractString(message, 'owner') as owner,
	JSONExtractString(message, 'connectionId') as connection_id
from (
	SELECT
        timestamp,
        height,
        txhash,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))),
	 '@type') AS type,
	        signer,
	        arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))) AS message
	    FROM spacebox.raw_transaction
    WHERE code = 0 and type = '/ibc.applications.interchain_accounts.controller.v1.MsgRegisterInterchainAccount'
)