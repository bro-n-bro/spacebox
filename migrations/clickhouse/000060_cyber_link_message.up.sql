-- 000060_cyber_link_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.cyber_link_message_topic
(
    `tx_hash`       String,
    `neuron`        String,
    `particle_from` String,
    `particle_to`   String,
    `height`        Int64,
    `msg_index`     Int64,
    `link_index`    Int64
) ENGINE = Kafka('kafka:9093', 'cyber_link_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cyber_link_message
(
    `tx_hash`       String,
    `neuron`        String,
    `particle_from` String,
    `particle_to`   String,
    `height`        Int64,
    `msg_index`     Int64,
    `link_index`    Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `msg_index`, `link_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS cyber_link_message_consumer TO spacebox.cyber_link_message AS
SELECT height, msg_index, link_index, tx_hash, neuron, particle_from, particle_to
FROM spacebox.cyber_link_message_topic
GROUP BY height, msg_index, link_index, tx_hash, neuron, particle_from, particle_to;
