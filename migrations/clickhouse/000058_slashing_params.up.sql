-- 000058_slashing_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.slashing_params_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'slashing_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.slashing_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS slashing_params_consumer TO spacebox.slashing_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.slashing_params_topic
GROUP BY height, params;