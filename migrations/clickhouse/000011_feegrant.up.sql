CREATE TABLE spacebox.feegrant_msg_allowance
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `granter` String,
    `grantee` String,
    `allowance` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 granter,
 grantee)
SETTINGS index_granularity = 8192;

-- DO NEED DENOM AND AMOUNT ?
CREATE MATERIALIZED VIEW spacebox.feegrant_msg_allowance_writer TO spacebox.feegrant_msg_allowance AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'granter') as granter,
    JSONExtractString(message, 'grantee') as grantee,
    JSONExtractString(message, 'allowance') as allowance
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
    WHERE code = 0 and type = '/cosmos.feegrant.v1beta1.MsgGrantAllowance'
);

-- RevokeAllowance - timeout