-- 000004_debs_and_creds.up.sql

-- spacebox.debs_and_creds definition

CREATE TABLE spacebox.debs_and_creds
(
    `height` Int64,
    `type` String,
    `address` String,
    `coins` String,
    `amount` Int64,
    `denom` String
)
ENGINE = MergeTree
ORDER BY (height,
 address,
 denom)
SETTINGS index_granularity = 8192;

-- spacebox.debs_and_creds_writer source

CREATE MATERIALIZED VIEW spacebox.debs_and_creds_writer TO spacebox.debs_and_creds
(
    `height` Int64,
    `type` String,
    `address` String,
    `coins` String,
    `amount` Int128,
    `denom` String
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
    )
SELECT
    height,
    type,
    if(type = 'coin_spent',
 JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'spender'),
 JSONExtractArrayRaw(attributes))[1],
 'value'),
 JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'receiver'),
 JSONExtractArrayRaw(attributes))[1],
 'value')) AS address,
    arrayJoin(splitByChar(',',
 JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'amount'),
 JSONExtractArrayRaw(attributes))[1],
 'value'))) AS coins,
    if(type = 'coin_spent',
 -toInt128OrZero(extract(coins,
 '^(\\d+)')),
 toInt128OrZero(extract(coins,
 '^(\\d+)'))) AS amount,
    extract(coins,
 '^\\d+(.*)') AS denom
FROM txs_events
WHERE (type = 'coin_received') OR (type = 'coin_spent');