-- 000034_distribution_commission.up.sql
CREATE TABLE IF NOT EXISTS spacebox.distribution_commission_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'distribution_commission', 'spacebox', 'JSONAsString');


CREATE TABLE IF NOT EXISTS spacebox.distribution_commission
(
    `operator_address` String,
    `amount`           String,
    `height`           Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS distribution_commission_consumer TO spacebox.distribution_commission
AS
SELECT JSONExtractString(message, 'operator_address') as operator_address,
       JSONExtractString(message, 'amount')           as amount,
       JSONExtractInt(message, 'height')              as height
FROM spacebox.distribution_commission_topic
GROUP BY operator_address, amount, height;


