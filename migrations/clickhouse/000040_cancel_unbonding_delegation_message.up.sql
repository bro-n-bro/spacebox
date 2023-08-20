-- 000040_cancel_unbonding_delegation_message.up.sql

CREATE TABLE IF NOT EXISTS spacebox.cancel_unbonding_delegation_message_topic
(
    `height`            Int64,
    `msg_index`         Int64,
    `tx_hash`           String,
    `delegator_address` String,
    `validator_address` String
) ENGINE = Kafka('kafka:9093', 'cancel_unbonding_delegation_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cancel_unbonding_delegation_message
(
    `height`            Int64,
    `msg_index`         Int64,
    `tx_hash`           String,
    `delegator_address` String,
    `validator_address` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS cancel_unbonding_delegation_message_consumer TO spacebox.cancel_unbonding_delegation_message
AS
SELECT height, msg_index, tx_hash, delegator_address, validator_address
FROM spacebox.cancel_unbonding_delegation_message_topic
GROUP BY height, msg_index, tx_hash, delegator_address, validator_address;

