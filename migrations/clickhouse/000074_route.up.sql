-- 000074_route.up.sql
CREATE TABLE IF NOT EXISTS spacebox.route_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'route', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.route
(
    `source`      String,
    `destination` String,
    `alias`       String,
    `value`       String,
    `timestamp`   TIMESTAMP,
    `height`      Int64,
    `is_active`   BOOL
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`source`, `destination`);

CREATE MATERIALIZED VIEW IF NOT EXISTS route_consumer TO spacebox.route AS
SELECT JSONExtractString(message, 'source')                                   as source,
       JSONExtractString(message, 'destination')                              as destination,
       JSONExtractString(message, 'alias')                                    as alias,
       JSONExtractString(message, 'value')                                    as value,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'timestamp')) AS timestamp,
       JSONExtractInt(message, 'height')                                      as height,
       JSONExtractBool(message, 'is_active')                                  as is_active
FROM spacebox.route_topic
GROUP BY source, destination, alias, value, timestamp, height, is_active;