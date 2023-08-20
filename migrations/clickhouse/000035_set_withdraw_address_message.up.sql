-- 000035_set_withdraw_address_message.up.sql

CREATE TABLE IF NOT EXISTS spacebox.set_withdraw_address_message_topic
(
    `height`            Int64,
    `tx_hash`           String,
    `msg_index`         Int64,
    `delegator_address` String,
    `withdraw_address`  String
) ENGINE = Kafka('kafka:9093', 'set_withdraw_address_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.set_withdraw_address_message
(
    `height`            Int64,
    `tx_hash`           String,
    `msg_index`         Int64,
    `delegator_address` String,
    `withdraw_address`  String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS set_withdraw_address_message_consumer TO spacebox.set_withdraw_address_message
AS
SELECT height, tx_hash, msg_index, delegator_address, withdraw_address
FROM spacebox.set_withdraw_address_message_topic
GROUP BY height, tx_hash, msg_index, delegator_address, withdraw_address;

