-- 000056_liquidity_pool.up.sql
CREATE TABLE IF NOT EXISTS spacebox.liquidity_pool_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'liquidity_pool', 'spacebox', 'JSONAsString');


CREATE TABLE IF NOT EXISTS spacebox.liquidity_pool
(
    `pool_id`                 UInt64,
    `reserve_account_address` String,
    `a_denom`                 String,
    `b_denom`                 String,
    `pool_coin_denom`         String,
    `liquidity_a`             String,
    `liquidity_b`             String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`pool_id`);

CREATE MATERIALIZED VIEW IF NOT EXISTS liquidity_pool_consumer TO spacebox.liquidity_pool
AS
SELECT JSONExtractUInt(message, 'pool_id')                   as pool_id,
       JSONExtractString(message, 'reserve_account_address') as reserve_account_address,
       JSONExtractString(message, 'a_denom')                 as a_denom,
       JSONExtractString(message, 'b_denom')                 as b_denom,
       JSONExtractString(message, 'pool_coin_denom')         as pool_coin_denom,
       JSONExtractString(message, 'liquidity_a')             as liquidity_a,
       JSONExtractString(message, 'liquidity_b')             as liquidity_b
FROM spacebox.liquidity_pool_topic
GROUP BY pool_id, reserve_account_address, a_denom, b_denom, pool_coin_denom, liquidity_a, liquidity_b;


