-- 000036_unjail_message.up.sql

CREATE TABLE IF NOT EXISTS spacebox.unjail_message_topic
(
    `height`           Int64,
    `tx_hash`          String,
    `msg_index`        Int64,
    `operator_address` String
) ENGINE = Kafka('kafka:9093', 'unjail_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.unjail_message
(
    `height`           Int64,
    `tx_hash`          String,
    `msg_index`        Int64,
    `operator_address` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS unjail_message_consumer TO spacebox.unjail_message
AS
SELECT height, tx_hash, msg_index, operator_address
FROM spacebox.unjail_message_topic
GROUP BY height, tx_hash, msg_index, operator_address;

