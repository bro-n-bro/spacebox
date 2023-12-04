-- 000066_grid_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.grid_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'grid_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.grid_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS grid_params_consumer TO spacebox.grid_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.grid_params_topic
GROUP BY height, params;