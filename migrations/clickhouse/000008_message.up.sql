-- 000008_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.message_topic
(
    `involved_accounts_addresses` Array(String),
    `transaction_hash` String,
    `msg_index`        Int64,
    `type`             String,
    `signer`           String,
    `value`            String
) ENGINE = Kafka('kafka:9093', 'message', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.message
(
    `involved_accounts_addresses` Array(String),
    `transaction_hash` String,
    `msg_index`        Int64,
    `type`             String,
    `signer`           String,
    `value`            String -- TODO: change to JSON
) ENGINE = ReplacingMergeTree()
      ORDER BY (`transaction_hash`, `msg_index`);

CREATE MATERIALIZED VIEW IF NOT EXISTS message_consumer TO spacebox.message
AS
SELECT involved_accounts_addresses, transaction_hash, msg_index, type, signer, FROM_BASE64(value) AS value
FROM spacebox.message_topic
GROUP BY involved_accounts_addresses, transaction_hash, msg_index, type, signer, value;

