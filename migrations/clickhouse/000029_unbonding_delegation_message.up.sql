-- 000029_unbonding_delegation_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.unbonding_delegation_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'unbonding_delegation_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.unbonding_delegation_message
(
    `operator_address`  String,
    `delegator_address` String,
    `coin`              String,
    `completion_time`   TIMESTAMP,
    `height`            Int64,
    `tx_hash`           String,
    `msg_index`         Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS unbonding_delegation_message_consumer TO spacebox.unbonding_delegation_message
AS
SELECT JSONExtractString(message, 'operator_address')                               as operator_address,
       JSONExtractString(message, 'delegator_address')                              as delegator_address,
       JSONExtractString(message, 'coin')                                           as coin,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'completion_time')) as completion_time,
       JSONExtractInt(message, 'height')                                            as height,
       JSONExtractString(message, 'tx_hash')                                        as tx_hash,
       JSONExtractInt(message, 'msg_index')                                         as msg_index
FROM spacebox.unbonding_delegation_message_topic
GROUP BY operator_address, delegator_address, coin, completion_time, height, tx_hash, msg_index;