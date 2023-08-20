-- 000057_validator_precommit.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_precommit_topic
(
    `height`            Int64,
    `block_id_flag`     UInt32,
    `validator_address` String,
    `timestamp`         String
) ENGINE = Kafka('kafka:9093', 'validator_precommit', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator_precommit
(
    `height`            Int64,
    `block_id_flag`     UInt32,
    `validator_address` String,
    `timestamp`         TIMESTAMP
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `validator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_precommit_consumer TO spacebox.validator_precommit
AS
SELECT height,
       block_id_flag,
       validator_address,
       parseDateTimeBestEffortOrZero(timestamp) AS timestamp
FROM spacebox.validator_precommit_topic
GROUP BY height, block_id_flag, validator_address, timestamp;
