-- 000037_revoke_message.up.sql

CREATE TABLE IF NOT EXISTS spacebox.revoke_message_topic
(
    `height`    Int64,
    `msg_index` Int64,
    `tx_hash`   String,
    `granter`   String,
    `grantee`   String,
    `msg_type`  String
) ENGINE = Kafka('kafka:9093', 'revoke_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.revoke_message
(
    `height`    Int64,
    `msg_index` Int64,
    `tx_hash`   String,
    `granter`   String,
    `grantee`   String,
    `msg_type`  String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS revoke_message_consumer TO spacebox.revoke_message
AS
SELECT height, msg_index, tx_hash, granter, grantee, msg_type
FROM spacebox.revoke_message_topic
GROUP BY height, msg_index, tx_hash, granter, grantee, msg_type;

