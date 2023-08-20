-- 000019_community_pool.up.sql
CREATE TABLE IF NOT EXISTS spacebox.community_pool_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'community_pool', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.community_pool
(
    `coins`  String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS community_pool_consumer TO spacebox.community_pool
AS
SELECT JSONExtractInt(message, 'height')   as height,
       JSONExtractString(message, 'coins') as coins
FROM spacebox.community_pool_topic
GROUP BY height, coins;