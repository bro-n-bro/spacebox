-- 000012_validator_status.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_status_topic
(
    `consensus_address` String,
    `status`            Int64,
    `jailed`            BOOL,
    `height`            Int64
) ENGINE = Kafka('kafka:9093', 'validator_status', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator_status
(
    `consensus_address` String,
    `status`            Int64,
    `jailed`            BOOL,
    `height`            Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`consensus_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_status_consumer TO spacebox.validator_status
AS
SELECT consensus_address, status, jailed, height
FROM spacebox.validator_status_topic
GROUP BY consensus_address, status, jailed, height;
