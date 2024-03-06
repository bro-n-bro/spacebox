-- 000075_raw_block.sql
CREATE TABLE IF NOT EXISTS spacebox.raw_block_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'raw_block', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.raw_block
(
    `height`           Int64,
    `hash`             String,
    `num_txs`          Int64,
    `total_gas`        Int64,
    `proposer_address` String,
    `timestamp`        DATETIME,
    `signatures`       String
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`height`, `timestamp`);


CREATE MATERIALIZED VIEW IF NOT EXISTS raw_block_consumer TO spacebox.raw_block AS
SELECT JSONExtractInt(message, 'block', 'header', 'height')                                 as height,
       JSONExtractString(message, 'hash')                                                   as hash,
       JSONExtractInt(message, 'num_txs')                                                   as num_txs,
       JSONExtractInt(message, 'total_gas')                                                 as total_gas,
       JSONExtractString(message, 'proposer_address')                                       as proposer_address,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'block', 'header', 'time')) as timestamp,
       JSONExtractString(message, 'block', 'last_commit', 'signatures')                     as signatures
FROM spacebox.raw_block_topic
GROUP BY height, hash, num_txs, total_gas, proposer_address, timestamp, signatures;