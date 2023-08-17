-- 000033_submit_proposal_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.submit_proposal_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'submit_proposal_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.submit_proposal_message
(
    `tx_hash`         String,
    `proposer`        String,
    `initial_deposit` String,
    `title`           String,
    `description`     String,
    `type`            String,
    `proposal_id`     Int64,
    `height`          Int64,
    `msg_index`       Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS submit_proposal_message_consumer TO spacebox.submit_proposal_message
AS
SELECT JSONExtractString(message, 'tx_hash')         as tx_hash,
       JSONExtractString(message, 'proposer')        as proposer,
       JSONExtractString(message, 'initial_deposit') as initial_deposit,
       JSONExtractString(message, 'title')           as title,
       JSONExtractString(message, 'description')     as description,
       JSONExtractString(message, 'type')            as type,
       JSONExtractInt(message, 'proposal_id')        as proposal_id,
       JSONExtractInt(message, 'height')             as height,
       JSONExtractInt(message, 'msg_index')          as msg_index
FROM spacebox.submit_proposal_message_topic
GROUP BY tx_hash, proposer, initial_deposit, title, description, type, proposal_id, height, msg_index;
