-- 000064_dmn_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.dmn_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'dmn_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.dmn_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS dmn_params_consumer TO spacebox.dmn_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.dmn_params_topic
GROUP BY height, params;