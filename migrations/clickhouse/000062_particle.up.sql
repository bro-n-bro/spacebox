-- 000062_particle.up.sql TODO: temporary
CREATE TABLE IF NOT EXISTS spacebox.particle_topic
(
    `particle`  String,
    `neuron`    String,
    `timestamp` String,
    `tx_hash`   String,
    `height`    Int64
) ENGINE = Kafka('kafka:9093', 'particle', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.particle
(
    `particle`  String,
    `neuron`    String,
    `timestamp` TIMESTAMP,
    `tx_hash`   String,
    `height`    Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`particle`);

CREATE MATERIALIZED VIEW IF NOT EXISTS particle_consumer TO spacebox.particle AS
SELECT particle, neuron, parseDateTimeBestEffortOrZero(timestamp) AS timestamp, height, tx_hash
FROM spacebox.particle_topic
GROUP BY particle, neuron, timestamp, height, tx_hash;
