-- TODO: @malekvictor, не шлется в кафку, надо разобраться почему.
-- 000017_validator_commission.up.sql
CREATE TABLE IF NOT EXISTS spacebox.validator_commission_topic
(
    `operator_address` String,
    `commission`       Float64,
    `max_change_rate`  Float64,
    `max_rate`         Float64,
    `height`           Int64
) ENGINE = Kafka('kafka:9093', 'validator_commission', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.validator_commission
(
    `operator_address` String,
    `commission`       Float64,
    `max_change_rate`  Float64,
    `max_rate`         Float64,
    `height`           Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS validator_commission_consumer TO spacebox.validator_commission
AS
SELECT operator_address, commission, max_change_rate, max_rate, height
FROM spacebox.validator_commission_topic
GROUP BY operator_address, commission, max_change_rate, max_rate, height;

