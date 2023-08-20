-- 000003_block.up.sql
CREATE TABLE IF NOT EXISTS spacebox.block_topic
(
    `height`           Int64,
    `hash`             String,
    `num_txs`          Int64,
    `total_gas`        Int64,
    `proposer_address` String,
    `timestamp`        String
) ENGINE = Kafka('kafka:9093', 'block', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.block
(
    `height`           Int64,
    `hash`             String,
    `num_txs`          Int64,
    `total_gas`        Int64,
    `proposer_address` String,
    `timestamp`        DATETIME

) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS block_consumer TO spacebox.block
AS
SELECT height, hash, num_txs, total_gas, proposer_address, parseDateTimeBestEffortOrNull(timestamp) as timestamp
FROM spacebox.block_topic
GROUP BY height, hash, num_txs, total_gas, proposer_address, timestamp;
