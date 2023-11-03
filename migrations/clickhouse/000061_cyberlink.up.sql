-- 000061_cyberlink.up.sql
CREATE TABLE IF NOT EXISTS spacebox.cyberlink_topic
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `tx_hash`       String,
    `timestamp`     String,
    `height`        Int64
) ENGINE = Kafka('kafka:9093', 'cyberlink', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.cyberlink
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `tx_hash`       String,
    `timestamp`     TIMESTAMP,
    `height`        Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`particle_from`, `particle_to`, `neuron`);

CREATE MATERIALIZED VIEW IF NOT EXISTS cyberlink_consumer TO spacebox.cyberlink AS
SELECT particle_from, particle_to, neuron, parseDateTimeBestEffortOrZero(timestamp) AS timestamp, height, tx_hash
FROM spacebox.cyberlink_topic
GROUP BY particle_from, particle_to, neuron, timestamp, height, tx_hash;
