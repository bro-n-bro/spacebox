-- 000076_raw_transaction.sql
CREATE TABLE IF NOT EXISTS spacebox.raw_transaction_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'raw_transaction', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.raw_transaction
(
    `timestamp`  DATETIME,
    `height`     Int64,
    `txhash`     String,
    `codespace`  String,
    `code`       Int64,
    `raw_log`    String, -- as is
    `logs`       String, -- correct JSON  array string
    `info`       String,
    `gas_wanted` Int64,
    `gas_used`   Int64,
    `tx`         String, -- correct JSON string
    `events`     String, -- correct JSON array string
    `signer`     String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`timestamp`, `height`, `txhash`, `signer`);

CREATE MATERIALIZED VIEW IF NOT EXISTS raw_transaction_consumer TO spacebox.raw_transaction AS
SELECT parseDateTimeBestEffortOrZero(JSONExtractString(message, 'tx_response', 'timestamp')) AS timestamp,
       toInt64(JSONExtractString(message, 'tx_response', 'height'))                          as height,
       JSONExtractString(message, 'tx_response', 'txhash')                                   as txhash,
       JSONExtractString(message, 'tx_response', 'codespace')                                as codespace,
       JSONExtractInt(message, 'tx_response', 'code')                                        as code,
       JSONExtractString(message, 'tx_response', 'rawLog')                                   as raw_log,
       JSONExtractString(message, 'tx_response', 'logs')                                     as logs,
       JSONExtractString(message, 'tx_response', 'info')                                     as info,
       toInt64(JSONExtractString(message, 'tx_response', 'gasWanted'))                       as gas_wanted,
       toInt64(JSONExtractString(message, 'tx_response', 'gasUsed'))                         as gas_used,
       JSONExtractString(message, 'tx_response', 'tx')                                       as tx,
       JSONExtractString(message, 'tx_response', 'events')                                   as events,
       JSONExtractString(message, 'signer')                                                  as signer
FROM spacebox.raw_transaction_topic
GROUP BY timestamp, height, txhash, codespace, code, raw_log, logs, info, gas_wanted, gas_used, tx, events, signer;