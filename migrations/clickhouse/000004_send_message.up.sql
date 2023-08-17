-- 000004_send_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.send_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'send_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.send_message
(
    `height`       Int64,
    `address_from` String,
    `address_to`   String,
    `tx_hash`      String,
    `coins`        String,
    `msg_index`    Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS send_message_consumer TO spacebox.send_message
AS
SELECT JSONExtractInt(message, 'height')          as height,
       JSONExtractString(message, 'address_from') as address_from,
       JSONExtractString(message, 'address_to')   as address_to,
       JSONExtractString(message, 'tx_hash')      as tx_hash,
       JSONExtractString(message, 'coins')        as coins,
       JSONExtractInt(message, 'msg_index')       as msg_index
FROM spacebox.send_message_topic
GROUP BY height, address_from, address_to, tx_hash, coins, msg_index;