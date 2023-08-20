-- 000048_proposer_reward.up.sql
CREATE TABLE IF NOT EXISTS spacebox.proposer_reward_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'proposer_reward', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.proposer_reward
(
    `height`           Int64,
    `operator_address` String,
    `reward`           String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `operator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS proposer_reward_consumer TO spacebox.proposer_reward
AS
SELECT JSONExtractInt(message, 'height')              as height,
       JSONExtractString(message, 'operator_address') as operator_address,
       JSONExtractString(message, 'reward')           as reward
FROM spacebox.proposer_reward_topic
GROUP BY height, operator_address, reward;