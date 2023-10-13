-- 000060_cyber_link_message.up.sql TODO: temporary
CREATE TABLE IF NOT EXISTS spacebox.cyber_link_message_topic
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `timestamp`     TIMESTAMP,
    `height`        Int64,
    `tx_hash`       String,
    `msg_index`     Int64
) ENGINE = Kafka('kafka:9093', 'cyber_link_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cyber_link_message
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

CREATE MATERIALIZED VIEW IF NOT EXISTS cyber_link_message_consumer TO spacebox.cyber_link_message AS
SELECT particle_from,
       particle_to,
       neuron,
       parseDateTimeBestEffortOrZero(timestamp) AS timestamp,
       height,
       tx_hash,
       msg_index
FROM spacebox.cyber_link_message_topic
GROUP BY particle_from, particle_to, neuron, timestamp, height, tx_hash, msg_index;
