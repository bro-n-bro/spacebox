-- 000078_raw_genesis.up.sql
CREATE TABLE IF NOT EXISTS spacebox.raw_genesis_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'raw_genesis', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.raw_genesis
(
    `genesis_time`     DATETIME,
    `chain_id`         String,
    `initial_height`   Int64,
    `consensus_params` String,
    `app_hash`         String,
    `app_state`        String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`genesis_time`, `chain_id`);

CREATE MATERIALIZED VIEW IF NOT EXISTS raw_genesis_consumer TO spacebox.raw_genesis AS
SELECT parseDateTimeBestEffortOrZero(JSONExtractString(message, 'genesis_time')) AS genesis_time,
       JSONExtractString(message, 'chain_id')                                    as chain_id,
       JSONExtractInt(message, 'initial_height')                                 as initial_height,
       JSONExtractString(message, 'consensus_params')                            as consensus_params,
       JSONExtractString(message, 'app_hash')                                    as app_hash,
       JSONExtractString(message, 'app_state')                                   as app_state
FROM spacebox.raw_genesis_topic
GROUP BY genesis_time, chain_id, initial_height, consensus_params, app_hash, app_state;