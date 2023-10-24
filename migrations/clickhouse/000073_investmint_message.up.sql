-- 000073_investmint_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.investmint_message_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'investmint_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.investmint_message
(
    `neuron`    String,
    `amount`    String,
    `resource`  String,
    `length`    UInt64,
    `tx_hash`   String,
    `msg_index` Int64,
    `height`    Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS investmint_message_consumer TO spacebox.investmint_message AS
SELECT JSONExtractString(message, 'neuron')   AS neuron,
       JSONExtractString(message, 'amount')   AS amount,
       JSONExtractString(message, 'resource') AS resource,
       JSONExtractUInt(message, 'length')     AS length,
       JSONExtractString(message, 'tx_hash')  AS tx_hash,
       JSONExtractInt(message, 'msg_index')   AS msg_index,
       JSONExtractInt(message, 'height')      AS height
FROM spacebox.investmint_message_topic
GROUP BY neuron, amount, resource, length, tx_hash, msg_index, height;
