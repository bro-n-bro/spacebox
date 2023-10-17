-- 000071_edit_route_name_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.edit_route_name_message_topic
(
    `source`      String,
    `destination` String,
    `name`        String,
    `tx_hash`     String,
    `height`      Int64,
    `msg_index`   Int64
) ENGINE = Kafka('kafka:9093', 'edit_route_name_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.edit_route_name_message
(
    `source`      String,
    `destination` String,
    `name`        String,
    `tx_hash`     String,
    `height`      Int64,
    `msg_index`   Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS edit_route_name_message_consumer TO spacebox.edit_route_name_message AS
SELECT source, destination, name, tx_hash, height, msg_index
FROM spacebox.edit_route_name_message_topic
GROUP BY source, destination, name, tx_hash, height, msg_index;
