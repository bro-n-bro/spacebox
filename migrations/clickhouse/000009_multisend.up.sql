-- spacebox.message_multisend definition

CREATE TABLE spacebox.message_multisend
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `from_address` String,
    `to_address` String,
    `denom` String,
    `amount` Int256
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 from_address,
 to_address)
SETTINGS index_granularity = 8192;

-- spacebox.message_multisend_writer source

CREATE MATERIALIZED VIEW spacebox.message_multisend_writer TO spacebox.message_multisend
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `from_address` String,
    `to_address` String,
    `denom` String,
    `amount` String
)
AS SELECT
    height,
    timestamp,
    txhash,
    from_address,
    to_address,
    JSONExtractString(coin,
 'denom') AS denom,
    JSONExtractString(coin,
 'amount') AS amount
FROM
(
    SELECT
        height,
        timestamp,
        txhash,
        JSONExtractString(JSONExtractArrayRaw(JSONExtractString(msg,
 'inputs'))[1],
 'address') AS from_address,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(msg,
 'outputs'))) AS output,
        JSONExtractString(output,
 'address') AS to_address,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(output,
 'coins'))) AS coin
    FROM
    (
        SELECT
            *,
            arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS msg,
            JSONExtractString(msg,
 '@type') AS type
        FROM spacebox.raw_transaction
        WHERE (type = '/cosmos.bank.v1beta1.MsgMultiSend') AND (code = 0)
    )
);