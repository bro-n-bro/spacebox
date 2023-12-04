-- 000067_rank_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.rank_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'rank_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.rank_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS rank_params_consumer TO spacebox.rank_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.rank_params_topic
GROUP BY height, params;