-- 000053_receive_packet_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.receive_packet_message_topic
(
    `source_port`         String,
    `source_channel`      String,
    `destination_port`    String,
    `destination_channel` String,
    `signer`              String,
    `data`                String,
    `timeout_timestamp`   UInt64,
    `height`              Int64,
    `msg_index`           Int64,
    `tx_hash`             String
) ENGINE = Kafka('kafka:9093', 'receive_packet_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.receive_packet_message
(
    `source_port`         String,
    `source_channel`      String,
    `destination_port`    String,
    `destination_channel` String,
    `signer`              String,
    `data`                String,
    `timeout_timestamp`   UInt64,
    `height`              Int64,
    `msg_index`           Int64,
    `tx_hash`             String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS receive_packet_message_consumer TO spacebox.receive_packet_message
AS
SELECT source_port,
       source_channel,
       destination_port,
       destination_channel,
       signer,
       FROM_BASE64(data) as data,
       timeout_timestamp,
       height,
       msg_index,
       tx_hash
FROM spacebox.receive_packet_message_topic
GROUP BY source_port, source_channel, destination_port, destination_channel, signer, data, timeout_timestamp, height,
         msg_index, tx_hash;
