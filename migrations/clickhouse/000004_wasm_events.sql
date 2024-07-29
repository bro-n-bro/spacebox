CREATE TABLE spacebox.wasm_events
(
    `timestamp` DateTime,
    `height` Int64,
    `contract_address` String,
    `action` String,
    `attributes` String,
    `signer` String,
    `txhash` String
)
ENGINE = MergeTree
ORDER BY (height, contract_address, action, signer, txhash)


CREATE MATERIALIZED VIEW spacebox.wasm_events_writer TO spacebox.wasm_events
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
WHERE type = 'wasm'