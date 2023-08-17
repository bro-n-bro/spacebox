-- 000025_staking_params.up.sql
CREATE TABLE IF NOT EXISTS spacebox.staking_params_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'staking_params', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.staking_params
(
    `params` String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);


CREATE MATERIALIZED VIEW IF NOT EXISTS staking_params_consumer TO spacebox.staking_params
AS
SELECT JSONExtractInt(message, 'height')    as height,
       JSONExtractString(message, 'params') as params
FROM spacebox.staking_params_topic
GROUP BY height, params;