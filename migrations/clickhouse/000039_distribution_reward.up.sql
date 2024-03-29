-- 000039_distribution_reward.up.sql
CREATE TABLE IF NOT EXISTS spacebox.distribution_reward_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'distribution_reward', 'spacebox', 'JSONAsString');


CREATE TABLE IF NOT EXISTS spacebox.distribution_reward
(
    `operator_address` String,
    `amount`           String,
    `height`           Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS distribution_reward_consumer TO spacebox.distribution_reward
AS
SELECT JSONExtractString(message, 'operator_address') as operator_address,
       JSONExtractString(message, 'amount')           as amount,
       JSONExtractInt(message, 'height')              as height
FROM spacebox.distribution_reward_topic
GROUP BY operator_address, amount, height;

