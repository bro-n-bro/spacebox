-- 000016_staking_pool.up.sql
CREATE TABLE IF NOT EXISTS spacebox.staking_pool_topic
(
    `height`            Int64,
    `not_bonded_tokens` Int64,
    `bonded_tokens`     Int64
) ENGINE = Kafka('kafka:9093', 'staking_pool', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.staking_pool
(
    `height`            Int64,
    `not_bonded_tokens` Int64,
    `bonded_tokens`     Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `not_bonded_tokens`, `bonded_tokens`);

CREATE MATERIALIZED VIEW IF NOT EXISTS staking_pool_consumer TO spacebox.staking_pool
AS
SELECT height, not_bonded_tokens, bonded_tokens
FROM spacebox.staking_pool_topic
GROUP BY height, not_bonded_tokens, bonded_tokens;

