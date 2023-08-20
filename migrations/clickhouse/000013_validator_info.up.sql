-- 000013_validator_info.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_info_topic
(
    `consensus_address`     String,
    `operator_address`      String,
    `self_delegate_address` String,
    `min_self_delegation`   Int64,
    `height`                Int64
) ENGINE = Kafka('kafka:9093', 'validator_info', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator_info
(
    `consensus_address`     String,
    `operator_address`      String,
    `self_delegate_address` String,
    `min_self_delegation`   Int64,
    `height`                Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`consensus_address`, `operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_info_consumer TO spacebox.validator_info
AS
SELECT consensus_address, operator_address, self_delegate_address, min_self_delegation, height
FROM spacebox.validator_info_topic
GROUP BY consensus_address, operator_address, self_delegate_address, min_self_delegation, height;
