-- 000074_route.up.sql
CREATE TABLE IF NOT EXISTS spacebox.route_topic
(
    `source`      String,
    `destination` String,
    `alias`       String,
    `value`       String,
    `timestamp`   String,
    `height`      Int64,
    `tx_hash`     String,
    `is_active`   BOOL
) ENGINE = Kafka('kafka:9093', 'route', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.route
(
    `source`      String,
    `destination` String,
    `alias`       String,
    `value`       String,
    `timestamp`   TIMESTAMP,
    `height`      Int64,
    `tx_hash`     String,
    `is_active`   BOOL
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`source`, `destination`);

CREATE MATERIALIZED VIEW IF NOT EXISTS route_consumer TO spacebox.route AS
SELECT source,
       destination,
       alias,
       value,
       parseDateTimeBestEffortOrZero(timestamp) AS timestamp,
       height,
       tx_hash,
       is_active
FROM spacebox.route_topic
GROUP BY source, destination, alias, value, timestamp, height, tx_hash, is_active;
