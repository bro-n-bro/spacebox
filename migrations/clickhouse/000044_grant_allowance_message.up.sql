-- 000044_grant_allowance_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.grant_allowance_message_topic
(
    `height`     Int64,
    `msg_index`  Int64,
    `tx_hash`    String,
    `granter`    String,
    `grantee`    String,
    `allowance`  String,
    `expiration` String
) ENGINE = Kafka('kafka:9093', 'grant_allowance_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.grant_allowance_message
(
    `height`     Int64,
    `msg_index`  Int64,
    `tx_hash`    String,
    `granter`    String,
    `grantee`    String,
    `allowance`  String,
    `expiration` TIMESTAMP
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS grant_allowance_message_consumer TO spacebox.grant_allowance_message
AS
SELECT height,
       msg_index,
       tx_hash,
       granter,
       grantee,
       FROM_BASE64(allowance)                    as allowance,
       parseDateTimeBestEffortOrZero(expiration) as expiration
FROM spacebox.grant_allowance_message_topic
GROUP BY height, msg_index, tx_hash, granter, grantee, allowance, expiration;


