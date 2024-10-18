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
from
(
	SELECT
		`timestamp`,
		height,
		txhash,
		message
	FROM spacebox.message
	WHERE `type` = '/ibc.applications.interchain_accounts.controller.v1.MsgRegisterInterchainAccount'
)
