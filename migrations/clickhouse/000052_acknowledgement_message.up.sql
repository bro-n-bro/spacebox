-- 000052_acknowledgement_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.acknowledgement_message_topic
(
    `source_port`         String,
    `source_channel`      String,
    `destination_port`    String,
    `destination_channel` String,
    `data`                String,
    `timeout_timestamp`   UInt64,
    `signer`              String,
    `height`              Int64,
    `msg_index`           Int64,
    `tx_hash`             String
) ENGINE = Kafka('kafka:9093', 'acknowledgement_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.acknowledgement_message
(
    `source_port`         String,
    `source_channel`      String,
    `destination_port`    String,
    `destination_channel` String,
    `data`                String,
    `timeout_timestamp`   UInt64,
    `signer`              String,
    `height`              Int64,
    `msg_index`           Int64,
    `tx_hash`             String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS acknowledgement_message_consumer TO spacebox.acknowledgement_message
AS
SELECT source_port,
       source_channel,
       destination_port,
       destination_channel,
       FROM_BASE64(data) as data,
       timeout_timestamp,
       signer,
       height,
       msg_index,
       tx_hash
FROM spacebox.acknowledgement_message_topic
GROUP BY source_port, source_channel, destination_port, destination_channel, data, timeout_timestamp, signer, height,
         msg_index, tx_hash;
