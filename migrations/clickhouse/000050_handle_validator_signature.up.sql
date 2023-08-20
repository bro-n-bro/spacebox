-- 000050_handle_validator_signature.up.sql
CREATE TABLE IF NOT EXISTS spacebox.handle_validator_signature_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'handle_validator_signature', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.handle_validator_signature
(
    `height`           Int64,
    `operator_address` String,
    `power`            String,
    `reason`           String,
    `jailed`           String,
    `burned`           String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS handle_validator_signature_consumer TO spacebox.handle_validator_signature
AS
SELECT JSONExtractInt(message, 'height')              as height,
       JSONExtractString(message, 'operator_address') as operator_address,
       JSONExtractString(message, 'power')            as power,
       JSONExtractString(message, 'reason')           as reason,
       JSONExtractString(message, 'jailed')           as jailed,
       JSONExtractString(message, 'burned')           as burned
FROM spacebox.handle_validator_signature_topic
GROUP BY height, operator_address, power, reason, jailed, burned;