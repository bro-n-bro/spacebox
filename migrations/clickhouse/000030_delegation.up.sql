-- 000030_delegation.up.sql
CREATE TABLE IF NOT EXISTS spacebox.delegation_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'delegation', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.delegation
(
    `operator_address`  String,
    `delegator_address` String,
    `coin`              String,
    `height`            Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`operator_address`, `delegator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS delegation_consumer TO spacebox.delegation
AS
SELECT JSONExtractString(message, 'operator_address')  as operator_address,
       JSONExtractString(message, 'delegator_address') as delegator_address,
       JSONExtractString(message, 'coin')              as coin,
       JSONExtractInt(message, 'height')            as height
FROM spacebox.delegation_topic
GROUP BY operator_address, delegator_address, coin, height;