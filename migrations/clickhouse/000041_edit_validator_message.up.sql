-- 000041_edit_validator_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.edit_validator_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'edit_validator_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.edit_validator_message
(
    `height`      Int64,
    `msg_index`   Int64,
    `tx_hash`     String,
    `description` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS edit_validator_message_consumer TO spacebox.edit_validator_message
AS
SELECT JSONExtractInt(message, 'height')         as height,
       JSONExtractInt(message, 'msg_index')      as msg_index,
       JSONExtractString(message, 'tx_hash')     as tx_hash,
       JSONExtractString(message, 'description') as description
FROM spacebox.edit_validator_message_topic
GROUP BY height, msg_index, tx_hash, description;