-- 000061_cyber_link.up.sql
CREATE TABLE IF NOT EXISTS spacebox.cyber_link_topic
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `tx_hash`       String,
    `timestamp`     String,
    `height`        Int64
) ENGINE = Kafka('kafka:9093', 'cyber_link', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cyber_link
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `tx_hash`       String,
    `timestamp`     TIMESTAMP,
    `height`        Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`particle_from`, `particle_to`, `neuron`);

CREATE MATERIALIZED VIEW IF NOT EXISTS cyber_link_consumer TO spacebox.cyber_link AS
SELECT particle_from, particle_to, neuron, parseDateTimeBestEffortOrZero(timestamp) AS timestamp, height, tx_hash
FROM spacebox.cyber_link_topic
GROUP BY particle_from, particle_to, neuron, timestamp, height, tx_hash;
