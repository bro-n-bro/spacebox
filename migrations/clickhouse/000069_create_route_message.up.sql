-- 000069_create_route_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.create_route_message_topic
(
    `source`      String,
    `destination` String,
    `name`        String,
    `tx_hash`     String,
    `height`      Int64,
    `msg_index`   Int64
) ENGINE = Kafka('kafka:9093', 'create_route_message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.create_route_message
(
    `source`      String,
    `destination` String,
    `name`        String,
    `tx_hash`     String,
    `height`      Int64,
    `msg_index`   Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS create_route_message_consumer TO spacebox.create_route_message AS
SELECT source, destination, name, tx_hash, height, msg_index
FROM spacebox.create_route_message_topic
GROUP BY source, destination, name, tx_hash, height, msg_index;
