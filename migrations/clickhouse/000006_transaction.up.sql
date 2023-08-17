-- 000006_transaction.up.sql
CREATE TABLE IF NOT EXISTS spacebox.transaction_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'transaction', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.transaction
(
    `signatures` Array(String),
    `hash`         String,
    `height`       Int64,
    `success`      BOOL,
    `messages`     String,
    `memo`         String,
    `signer_infos` String,
    `fee`          String,
    `signer`       String,
    `gas_wanted`   Int64,
    `gas_used`     Int64,
    `raw_log`      String,
    `logs`         String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`hash`);


CREATE MATERIALIZED VIEW IF NOT EXISTS transaction_consumer TO spacebox.transaction
AS
SELECT JSONExtractArrayRaw(message, 'signatures')                                                          as signatures,
       JSONExtractString(message, 'hash')                                                                  as hash,
       JSONExtractInt(message, 'height')                                                                   as height,
       JSONExtractBool(message, 'success')                                                                 as success,
       toString(arrayMap(x -> FROM_BASE64(replace(x, '"', '')), JSONExtractArrayRaw(message, 'messages'))) as messages,
       JSONExtractString(message, 'memo')                                                                  as memo,
       JSONExtractString(message, 'signer_infos')                                                          as signer_infos,
       JSONExtractString(message, 'fee')                                                                   as fee,
       JSONExtractString(message, 'signer')                                                                as signer,
       JSONExtractInt(message, 'gas_wanted')                                                               as gas_wanted,
       JSONExtractInt(message, 'gas_used')                                                                 as gas_used,
       JSONExtractString(message, 'raw_log')                                                               as raw_log,
       JSONExtractInt(message, 'logs')                                                                     as logs
FROM spacebox.transaction_topic
GROUP BY signatures, hash, height, success, messages, memo, signer_infos, fee, signer, gas_wanted, gas_used, raw_log,
         logs;