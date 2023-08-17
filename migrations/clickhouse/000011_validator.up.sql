-- 000011_validator.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_topic
(
    `consensus_address` String,
    `operator_address`  String,
    `consensus_pubkey`  String,
    `height`            Int64
) ENGINE = Kafka('kafka:9093', 'validator', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator
(
    `consensus_address` String,
    `operator_address`  String,
    `consensus_pubkey`  String,
    `height`            Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`consensus_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_consumer TO spacebox.validator
AS
SELECT consensus_address, operator_address, consensus_pubkey, height
FROM spacebox.validator_topic
GROUP BY consensus_address, operator_address, consensus_pubkey, height;
