-- 000043_exec_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.exec_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'exec_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.exec_message
(
    `height`    Int64,
    `msg_index` Int64,
    `tx_hash`   String,
    `grantee`   String,
    `msgs`      String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS exec_message_consumer TO spacebox.exec_message
AS
SELECT JSONExtractInt(message, 'height')                                                                   as height,
       JSONExtractInt(message, 'msg_index')                                                                as msg_index,
       JSONExtractString(message, 'tx_hash')                                                               as tx_hash,
       JSONExtractString(message, 'grantee')                                                               as grantee,
       toJSONString(arrayMap(x -> FROM_BASE64(replace(x, '"', '')), JSONExtractArrayRaw(message, 'msgs'))) as msgs
FROM spacebox.exec_message_topic
GROUP BY height, msg_index, tx_hash, grantee, msgs;