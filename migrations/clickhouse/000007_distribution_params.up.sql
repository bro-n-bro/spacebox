-- 000007_distribution_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.distribution_params_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'distribution_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.distribution_params
(
    `height` Int64,
    `params` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS distribution_params_consumer TO spacebox.distribution_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.distribution_params_topic
GROUP BY height, params;