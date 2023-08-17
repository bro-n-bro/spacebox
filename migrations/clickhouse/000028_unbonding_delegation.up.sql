-- 000028_unbonding_delegation.up.sql
CREATE TABLE IF NOT EXISTS spacebox.unbonding_delegation_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'unbonding_delegation', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.unbonding_delegation
(
    `operator_address`  String,
    `delegator_address` String,
    `coin`              String,
    `completion_time`   TIMESTAMP,
    `height`            Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`operator_address`, `delegator_address`, `completion_time`, `height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS unbonding_delegation_consumer TO spacebox.unbonding_delegation
AS
SELECT JSONExtractString(message, 'operator_address')                               as operator_address,
       JSONExtractString(message, 'delegator_address')                              as delegator_address,
       JSONExtractString(message, 'coin')                                           as coin,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'completion_time')) as completion_time,
       JSONExtractInt(message, 'height')                                            as height
FROM spacebox.unbonding_delegation_topic
GROUP BY operator_address, delegator_address, coin, completion_time, height;