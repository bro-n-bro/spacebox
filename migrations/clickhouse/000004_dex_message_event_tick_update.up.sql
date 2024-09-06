CREATE TABLE spacebox.dex_message_event_tick_update
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `attributes` String,
    `signer` String,
    `TokenZero` String,
    `TokenOne` String,
    `TokenIn` String,
    `TickIndex` Int32,
    `TrancheKey` String,
    `Fee` UInt16,
    `Reserves` Int256
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 signer,
 TokenZero,
 TokenOne,
 TokenIn,
 TickIndex,
 TrancheKey)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.dex_message_event_tick_update_writer TO spacebox.dex_message_event_tick_update
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `attributes` String,
    `signer` String,
    `TokenZero` String,
    `TokenOne` String,
    `TokenIn` String,
    `TickIndex` Int32,
    `TrancheKey` String,
    `Fee` UInt16,
    `Reserves` UInt256
) AS
WITH
    raw_tx AS
    (
        SELECT
            timestamp,
            height,
            txhash,
            events,
            signer
        FROM spacebox.raw_transaction
        WHERE code = 0
    ),
    raw_tx_event AS
    (
        SELECT
            timestamp,
            height,
            txhash,
            type,
            attributes,
            signer
        FROM raw_tx
        ARRAY JOIN
            arrayMap(x -> JSONExtractString(x,
 'type'),
 JSONExtractArrayRaw(events)) AS type,
            arrayMap(x -> JSONExtractString(x,
 'attributes'),
 JSONExtractArrayRaw(events)) AS attributes
    ),
    dex_message_event AS
    (
        SELECT
            timestamp,
            height,
            txhash,
            type,
            attributes,
            JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'action'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS action,
            signer
        FROM raw_tx_event
        WHERE JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'module'),
 JSONExtractArrayRaw(attributes))[1],
 'value') = 'dex'
    )
SELECT
    timestamp,
    height,
    txhash,
    attributes,
    signer,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'TokenZero'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS TokenZero,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'TokenOne'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS TokenOne,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'TokenIn'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS TokenIn,
    toInt32(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'TickIndex'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS TickIndex,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'TrancheKey'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS TrancheKey,
    if(empty(TrancheKey) = 1,
 toUInt16OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'Fee'),
 JSONExtractArrayRaw(attributes))[1],
 'value')),
 0) AS Fee,
    toUInt256(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'Reserves'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS Reserves
FROM dex_message_event
WHERE action = 'TickUpdate';
