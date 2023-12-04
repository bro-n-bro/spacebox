-- 000065_graph_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.graph_params_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'graph_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.graph_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
    ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS graph_params_consumer TO spacebox.graph_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.graph_params_topic
GROUP BY height, params;