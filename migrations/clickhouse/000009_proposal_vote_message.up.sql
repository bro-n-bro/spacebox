-- 000009_proposal_vote_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.proposal_vote_message_topic
(
    `proposal_id` Int64,
    `voter`       String,
    `option`      String,
    `height`      Int64,
    `tx_hash`     String,
    `msg_index`   Int64
) ENGINE = Kafka('kafka:9093', 'proposal_vote_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.proposal_vote_message
(
    `proposal_id` Int64,
    `voter`       String,
    `option`      String,
    `height`      Int64,
    `tx_hash`     String,
    `msg_index`   Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS proposal_vote_message_consumer TO spacebox.proposal_vote_message
AS
SELECT proposal_id, voter, option, height, tx_hash, msg_index
FROM spacebox.proposal_vote_message_topic
GROUP BY proposal_id, voter, option, height, tx_hash, msg_index;
