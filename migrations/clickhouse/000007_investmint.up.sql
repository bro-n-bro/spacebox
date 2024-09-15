-- spacebox.message_investmint definition

CREATE TABLE spacebox.message_investmint
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `denom` String,
    `amount` Int256,
    `agent` String,
    `resource` String,
    `length` Int256
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 agent)
SETTINGS index_granularity = 8192;


-- spacebox.message_investmint_writer source

CREATE MATERIALIZED VIEW spacebox.message_investmint_writer TO spacebox.message_investmint
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `denom` String,
    `amount` String,
    `agent` String,
    `resource` String,
    `length` String
)
AS SELECT
    timestamp,
    height,
    txhash,
    JSONExtractString(msg,
 'amount',
 'denom') AS denom,
    JSONExtractString(msg,
 'amount',
 'amount') AS amount,
    JSONExtractString(msg,
 'neuron') AS agent,
    JSONExtractString(msg,
 'resource') AS resource,
    JSONExtractString(msg,
 'length') AS length
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
    WHERE (type = '/cyber.resources.v1beta1.MsgInvestmint') AND (code = 0)
);