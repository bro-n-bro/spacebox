-- 000062_particles.up.sql TODO: temporary
CREATE TABLE IF NOT EXISTS spacebox.particles_topic
(
    `particle_from` String,
    `particle_to`   String,
    `neuron`        String,
    `timestamp`     TIMESTAMP,
    `height`        Int64,
    `tx_hash`       String,
    `msg_index`     Int64
) ENGINE = Kafka('kafka:9093', 'particles', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.particles
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

CREATE MATERIALIZED VIEW IF NOT EXISTS particles_consumer TO spacebox.particles AS
SELECT particle_from,
       particle_to,
       neuron,
       parseDateTimeBestEffortOrZero(timestamp) AS timestamp,
       height,
       tx_hash,
       msg_index
FROM spacebox.particles_topic
GROUP BY particle_from, particle_to, neuron, timestamp, height, tx_hash, msg_index;
