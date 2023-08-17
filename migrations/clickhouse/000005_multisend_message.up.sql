-- 000005_multisend_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.multisend_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'multisend_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.multisend_message
(
    `height`       Int64,
    `address_from` String,
    `addresses_to` Array(String),
    `tx_hash`      String,
    `coins`        String,
    `msg_index`    Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS multisend_message_consumer TO spacebox.multisend_message
AS
SELECT JSONExtractInt(message, 'height')            as height,
       JSONExtractString(message, 'address_from')   as address_from,
       JSONExtractArrayRaw(message, 'addresses_to') as addresses_to,
       JSONExtractString(message, 'tx_hash')        as tx_hash,
       JSONExtractString(message, 'coins')          as coins,
       JSONExtractInt(message, 'msg_index')         as msg_index
FROM spacebox.multisend_message_topic
GROUP BY height, address_from, addresses_to, tx_hash, coins, msg_index;