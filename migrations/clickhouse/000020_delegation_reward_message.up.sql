-- 000020_delegation_reward_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.delegation_reward_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'delegation_reward_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.delegation_reward_message
(
    `operator_address`  String,
    `delegator_address` String,
    `coins`             String,
    `height`            Int64,
    `tx_hash`           String,
    `msg_index`         Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS delegation_reward_message_consumer TO spacebox.delegation_reward_message
AS
SELECT JSONExtractString(message, 'operator_address')  as operator_address,
       JSONExtractString(message, 'delegator_address') as delegator_address,
       JSONExtractString(message, 'coins')             as coins,
       JSONExtractInt(message, 'height')               as height,
       JSONExtractString(message, 'tx_hash')           as tx_hash,
       JSONExtractInt(message, 'msg_index')            as msg_index
FROM spacebox.delegation_reward_message_topic
GROUP BY operator_address, delegator_address, coins, height, tx_hash, msg_index;