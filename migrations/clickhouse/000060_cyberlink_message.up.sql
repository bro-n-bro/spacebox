-- 000060_cyberlink_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.cyberlink_message_topic
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `timestamp`     TIMESTAMP,
    `height`        Int64,
    `tx_hash`       String,
    `msg_index`     Int64
) ENGINE = Kafka('kafka:9093', 'cyberlink_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cyberlink_message
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `timestamp`     TIMESTAMP,
    `height`        Int64,
    `tx_hash`       String,
    `msg_index`     Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`particle_from`, `particle_to`, `neuron`);

CREATE MATERIALIZED VIEW IF NOT EXISTS cyberlink_message_consumer TO spacebox.cyberlink_message AS
SELECT particle_from, particle_to, neuron, timestamp, height, tx_hash, msg_index
FROM spacebox.cyberlink_message_topic
GROUP BY particle_from, particle_to, neuron, timestamp, height, tx_hash, msg_index;
