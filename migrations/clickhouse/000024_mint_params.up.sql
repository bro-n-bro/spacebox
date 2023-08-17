-- 000024_mint_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.mint_params_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'mint_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.mint_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS mint_params_consumer TO spacebox.mint_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.mint_params_topic
GROUP BY height, params;