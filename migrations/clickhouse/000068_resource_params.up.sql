-- 000068_resource_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.resource_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'resource_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.resource_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS resource_params_consumer TO spacebox.resource_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.resource_params_topic
GROUP BY height, params;