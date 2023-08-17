-- 000046_grant_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.grant_message_topic
(
    `height`     Int64,
    `msg_index`  Int64,
    `tx_hash`    String,
    `granter`    String,
    `grantee`    String,
    `msg_type`   String,
    `expiration` String
) ENGINE = Kafka('kafka:9093', 'grant_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.grant_message
(
    `height`     Int64,
    `msg_index`  Int64,
    `tx_hash`    String,
    `granter`    String,
    `grantee`    String,
    `msg_type`   String,
    `expiration` TIMESTAMP
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS grant_message_consumer TO spacebox.grant_message
AS
SELECT height, msg_index, tx_hash, granter, grantee, msg_type, parseDateTimeBestEffortOrZero(expiration) as expiration
FROM spacebox.grant_message_topic
GROUP BY height, msg_index, tx_hash, granter, grantee, msg_type, expiration;


