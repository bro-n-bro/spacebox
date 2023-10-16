-- 000063_bandwidth_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.bandwidth_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'bandwidth_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.bandwidth_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS bandwidth_params_consumer TO spacebox.bandwidth_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.bandwidth_params_topic
GROUP BY height, params;