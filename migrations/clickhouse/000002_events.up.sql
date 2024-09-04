CREATE TABLE spacebox.txs_events
(
    `height` Int64,
    `type` String,
    `attributes` String
)
ENGINE = MergeTree
ORDER BY (height,
 type)
SETTINGS index_granularity = 8192;

-- spacebox.txs_events_writer source

CREATE MATERIALIZED VIEW spacebox.txs_events_writer TO spacebox.txs_events
(
    `height` Int64,
    `type` String,
    `attributes` String
) AS
SELECT *
FROM
(
    SELECT
        height,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(txs_results))),
 'events'))),
 'type') AS type,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(txs_results))),
 'events'))),
 'attributes') AS attributes
    FROM spacebox.raw_block_results
);

-- spacebox.wasm_txs_events definition

CREATE TABLE spacebox.wasm_txs_events
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `signer` String,
    `contract_address` String,
    `action` String,
    `attributes` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 signer,
 contract_address,
 action)
SETTINGS index_granularity = 8192;

-- spacebox.wasm_txs_events_writer source

CREATE MATERIALIZED VIEW spacebox.wasm_txs_events_writer TO spacebox.wasm_txs_events
(

    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `signer` String,
    `contract_address` String,
    `action` String,
    `attributes` String
) AS
WITH events AS
    (
        SELECT
            timestamp,
            height,
            txhash,
            signer,
            JSONExtractString(arrayJoin(JSONExtractArrayRaw(events)),
 'type') AS type,
            JSONExtractString(arrayJoin(JSONExtractArrayRaw(events)),
 'attributes') AS attributes
        FROM spacebox.raw_transaction
    )
SELECT
    timestamp,
    height,
    txhash,
    signer,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = '_contract_address'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS contract_address,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'action'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS action,
    attributes
FROM events
WHERE type = 'wasm';