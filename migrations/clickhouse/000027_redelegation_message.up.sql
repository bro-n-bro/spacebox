-- 000027_redelegation_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.redelegation_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'redelegation_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.redelegation_message
(
    `delegator_address`     String,
    `src_validator_address` String,
    `dst_validator_address` String,
    `coin`                  String,
    `height`                Int64,
    `completion_time`       TIMESTAMP,
    `tx_hash`               String,
    `msg_index`             Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS redelegation_message_consumer TO spacebox.redelegation_message
AS
SELECT JSONExtractString(message, 'delegator_address')                              as delegator_address,
       JSONExtractString(message, 'src_validator_address')                          as src_validator_address,
       JSONExtractString(message, 'dst_validator_address')                          as dst_validator_address,
       JSONExtractString(message, 'coin')                                           as coin,
       JSONExtractInt(message, 'height')                                            as height,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'completion_time')) as completion_time,
       JSONExtractString(message, 'tx_hash')                                        as tx_hash,
       JSONExtractInt(message, 'msg_index')                                         as msg_index
FROM spacebox.redelegation_message_topic
GROUP BY delegator_address, src_validator_address, dst_validator_address, coin, height, completion_time, tx_hash,
         msg_index;