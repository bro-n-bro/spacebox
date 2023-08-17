-- 000051_transfer_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.transfer_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'transfer_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.transfer_message
(
    `source_channel` String,
    `coin`           String,
    `sender`         String,
    `receiver`       String,
    `height`         Int64,
    `msg_index`      Int64,
    `tx_hash`        String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS transfer_message_consumer TO spacebox.transfer_message
AS
SELECT JSONExtractString(message, 'source_channel') as source_channel,
       JSONExtractString(message, 'coin')           as coin,
       JSONExtractString(message, 'sender')         as sender,
       JSONExtractString(message, 'receiver')       as receiver,
       JSONExtractInt(message, 'height')            as height,
       JSONExtractInt(message, 'msg_index')         as msg_index,
       JSONExtractString(message, 'tx_hash')        as tx_hash
FROM spacebox.transfer_message_topic
GROUP BY source_channel, coin, sender, receiver, height, msg_index, tx_hash;
