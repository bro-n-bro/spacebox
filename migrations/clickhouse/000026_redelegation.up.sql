-- 000026_redelegation.up.sql
CREATE TABLE IF NOT EXISTS spacebox.redelegation_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'redelegation', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.redelegation
(
    `delegator_address`     String,
    `src_validator_address` String,
    `dst_validator_address` String,
    `coin`                  String,
    `height`                Int64,
    `completion_time`       TIMESTAMP
) ENGINE = ReplacingMergeTree()
      ORDER BY (`delegator_address`, `src_validator_address`, `dst_validator_address`, `height`, `completion_time`);


CREATE MATERIALIZED VIEW IF NOT EXISTS redelegation_consumer TO spacebox.redelegation
AS
SELECT JSONExtractString(message, 'delegator_address')                              as delegator_address,
       JSONExtractString(message, 'src_validator_address')                          as src_validator_address,
       JSONExtractString(message, 'dst_validator_address')                          as dst_validator_address,
       JSONExtractString(message, 'coin')                                           as coin,
       JSONExtractInt(message, 'height')                                            as height,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'completion_time')) as completion_time
FROM spacebox.redelegation_topic
GROUP BY delegator_address, src_validator_address, dst_validator_address, coin, height, completion_time;