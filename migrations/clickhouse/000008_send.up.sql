-- spacebox.message_send definition

CREATE TABLE spacebox.message_send
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

-- spacebox.message_send_writer source

CREATE MATERIALIZED VIEW spacebox.message_send_writer TO spacebox.message_send
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
    JSONExtractString(msg,
 'fromAddress') AS from_address,
    JSONExtractString(msg,
 'toAddress') AS to_address,
    JSONExtractString(amount_info,
 'denom') AS denom,
    JSONExtractString(amount_info,
 'amount') AS amount
FROM
(
    SELECT
        *,
        JSONExtractString(msg,
 'fromAddress') AS from_address,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(msg,
 'amount'))) AS amount_info,
        JSONExtractString(msg,
 'toAddress') AS to_address
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
        WHERE (type = '/cosmos.bank.v1beta1.MsgSend') AND (code = 0)
    )
);