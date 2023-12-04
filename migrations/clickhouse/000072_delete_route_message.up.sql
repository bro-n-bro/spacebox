-- 000072_delete_route_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.delete_route_message_topic
(
    `tx_hash`     String,
    `source`      String,
    `destination` String,
    `height`      Int64,
    `msg_index`   Int64

) ENGINE = Kafka('kafka:9093', 'delete_route_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.delete_route_message
(
    `tx_hash`     String,
    `source`      String,
    `destination` String,
    `height`      Int64,
    `msg_index`   Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS delete_route_message_consumer TO spacebox.delete_route_message AS
SELECT tx_hash, source, destination, height, msg_index
FROM spacebox.delete_route_message_topic
GROUP BY tx_hash, source, destination, height, msg_index;
