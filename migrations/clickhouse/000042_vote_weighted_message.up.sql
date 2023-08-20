-- 000042_vote_weighted_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.vote_weighted_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'vote_weighted_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.vote_weighted_message
(
    `height`               Int64,
    `msg_index`            Int64,
    `proposal_id`          Int64,
    `tx_hash`              String,
    `voter`                String,
    `weighted_vote_option` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS vote_weighted_message_consumer TO spacebox.vote_weighted_message
AS
SELECT JSONExtractInt(message, 'height')                  as height,
       JSONExtractInt(message, 'msg_index')               as msg_index,
       JSONExtractInt(message, 'proposal_id')             as proposal_id,
       JSONExtractString(message, 'tx_hash')              as tx_hash,
       JSONExtractString(message, 'voter')                as voter,
       JSONExtractString(message, 'weighted_vote_option') as weighted_vote_option
FROM spacebox.vote_weighted_message_topic
GROUP BY height, msg_index, proposal_id, tx_hash, voter, weighted_vote_option;