-- 000045_revoke_allowance_message.up.sql

CREATE TABLE IF NOT EXISTS spacebox.revoke_allowance_message_topic
(
    `height`    Int64,
    `msg_index` Int64,
    `tx_hash`   String,
    `grantee`   String,
    `granted`   String
) ENGINE = Kafka('kafka:9093', 'revoke_allowance_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.revoke_allowance_message
(
    `height`    Int64,
    `msg_index` Int64,
    `tx_hash`   String,
    `grantee`   String,
    `granted`   String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS revoke_allowance_message_consumer TO spacebox.revoke_allowance_message
AS
SELECT height, msg_index, tx_hash, granted, grantee
FROM spacebox.revoke_allowance_message_topic
GROUP BY height, msg_index, tx_hash, granted, grantee;

