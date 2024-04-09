-- 000006_wasm.up.sql

-- spacebox.wasm_swaps definition

CREATE TABLE spacebox.wasm_swaps
(
    `height` Int64,
    `contract_address` String,
    `action` String,
    `ask_asset` String,
    `commission_amount` Int128,
    `maker_fee_amount` Int128,
    `offer_amount` Int128,
    `offer_asset` String,
    `receiver` String,
    `return_amount` Int128,
    `sender` String,
    `spread_amount` Int128
)
ENGINE = MergeTree
ORDER BY (height,
 contract_address,
 ask_asset,
 offer_asset,
 sender,
 receiver)
SETTINGS index_granularity = 8192;

-- spacebox.wasm_swaps_writer source

CREATE MATERIALIZED VIEW spacebox.wasm_swaps_writer TO spacebox.wasm_swaps
(
    `height` Int64,
    `contract_address` String,
    `action` String,
    `ask_asset` String,
    `commission_amount` Int128,
    `maker_fee_amount` Int128,
    `offer_amount` Int128,
    `offer_asset` String,
    `receiver` String,
    `return_amount` Int128,
    `sender` String,
    `spread_amount` Int128
) AS
WITH _wasm_swaps AS
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
        WHERE type = 'wasm'
    )
SELECT
    height,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = '_contract_address'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS contract_address,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'action'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS action,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'ask_asset'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS ask_asset,
    toInt128OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'commission_amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS commission_amount,
    toInt128OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'maker_fee_amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS maker_fee_amount,
    toInt128OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'offer_amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS offer_amount,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'offer_asset'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS offer_asset,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'receiver'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS receiver,
    toInt128OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'return_amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS return_amount,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'sender'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS sender,
    toInt128OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'spread_amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS spread_amount
FROM _wasm_swaps
WHERE action = 'swap';

-- spacebox.wasm_votes definition

CREATE TABLE spacebox.wasm_votes
(
    `height` Int64,
    `contract_address` String,
    `action` String,
    `sender` String,
    `proposal_id` Int64,
    `position` String,
    `status` String
)
ENGINE = MergeTree
ORDER BY (height,
 contract_address,
 sender,
 proposal_id,
 position)
SETTINGS index_granularity = 8192;

-- spacebox.wasm_votes_writer source

CREATE MATERIALIZED VIEW spacebox.wasm_votes_writer TO spacebox.wasm_votes
(
    `height` Int64,
    `contract_address` String,
    `action` String,
    `sender` String,
    `proposal_id` Int64,
    `position` String,
    `status` String
) AS
WITH txs_events AS
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
        WHERE type = 'wasm'
    )
SELECT
    height,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = '_contract_address'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS contract_address,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'action'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS action,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'sender'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS sender,
    toInt64OrZero(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'proposal_id'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS proposal_id,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'position'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS position,
    JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'status'),
 JSONExtractArrayRaw(attributes))[1],
 'value') AS status
FROM txs_events
WHERE action = 'vote';