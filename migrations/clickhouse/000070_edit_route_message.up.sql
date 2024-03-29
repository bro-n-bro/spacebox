-- 000070_edit_route_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.edit_route_message_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'edit_route_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.edit_route_message
(
    `source`      String,
    `destination` String,
    `value`       String,
    `tx_hash`     String,
    `msg_index`   Int64,
    `height`      Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS edit_route_message_consumer TO spacebox.edit_route_message AS
SELECT JSONExtractString(message, 'source')      AS source,
       JSONExtractString(message, 'destination') AS destination,
       JSONExtractString(message, 'value')       AS value,
       JSONExtractString(message, 'tx_hash')     AS tx_hash,
       JSONExtractInt(message, 'msg_index')      AS msg_index,
       JSONExtractInt(message, 'height')         AS height
FROM spacebox.edit_route_message_topic
GROUP BY source, destination, value, tx_hash, msg_index, height;
