-- 000001_raw.up.sql
-- spacebox.raw_block_topic definition

CREATE TABLE spacebox.raw_block_topic
(

    `message` String
)
    ENGINE = Kafka
        SETTINGS kafka_broker_list = 'kafka:9093',
            kafka_topic_list = 'raw_block',
            kafka_group_name = 'spacebox',
            kafka_format = 'JSONAsString',
            kafka_flush_interval_ms = 3600000;

-- spacebox.raw_block definition

CREATE TABLE spacebox.raw_block
(
    `height`           Int64,
    `hash`             String,
    `num_txs`          Int64,
    `total_gas`        Int64,
    `proposer_address` String,
    `timestamp`        DATETIME,
    `signatures`       String
)
    ENGINE = ReplacingMergeTree
        ORDER BY (height,
                  timestamp)
        SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW IF NOT EXISTS raw_block_consumer TO spacebox.raw_block AS
SELECT JSONExtractInt(message, 'block', 'header', 'height')                                 AS height,
       JSONExtractString(message, 'hash')                                                   AS hash,
       JSONExtractInt(message, 'num_txs')                                                   AS num_txs,
       JSONExtractInt(message, 'total_gas')                                                 AS total_gas,
       JSONExtractString(message, 'proposer_address')                                       AS proposer_address,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'block', 'header', 'time')) AS timestamp,
       JSONExtractString(message, 'block', 'last_commit', 'signatures')                     AS signatures
FROM spacebox.raw_block_topic
GROUP BY height, hash, num_txs, total_gas, proposer_address, timestamp, signatures;

-- spacebox.raw_block_results_topic definition

CREATE TABLE spacebox.raw_block_results_topic
(

    `message` String
)
    ENGINE = Kafka
        SETTINGS kafka_broker_list = 'kafka:9093',
            kafka_topic_list = 'raw_block_results',
            kafka_group_name = 'spacebox',
            kafka_format = 'JSONAsString',
            kafka_flush_interval_ms = 3600000;


-- spacebox.raw_block_results definition

CREATE TABLE spacebox.raw_block_results
(

    `height`                  Int64,
    `txs_results`             String,
    `begin_block_events`      String,
    `end_block_events`        String,
    `validator_updates`       String,
    `consensus_param_updates` String,
    `timestamp`               DATETIME
)
    ENGINE = ReplacingMergeTree
        ORDER BY height
        SETTINGS index_granularity = 8192;

-- spacebox.raw_transaction_topic definition

CREATE TABLE spacebox.raw_transaction_topic
(

    `message` String
)
    ENGINE = Kafka
        SETTINGS kafka_broker_list = 'kafka:9093',
            kafka_topic_list = 'raw_transaction',
            kafka_group_name = 'spacebox',
            kafka_format = 'JSONAsString',
            kafka_flush_interval_ms = 3600000;


CREATE MATERIALIZED VIEW IF NOT EXISTS raw_block_results_consumer TO spacebox.raw_block_results AS
SELECT JSONExtractInt(message, 'height')                                      AS height,
       JSONExtractString(message, 'txs_results')                              AS txs_results,
       JSONExtractString(message, 'begin_block_events')                       AS begin_block_events,
       JSONExtractString(message, 'end_block_events')                         AS end_block_events,
       JSONExtractString(message, 'validator_updates')                        AS validator_updates,
       JSONExtractString(message, 'consensus_param_updates')                  AS consensus_param_updates,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'timestamp')) AS timestamp
FROM spacebox.raw_block_results_topic
GROUP BY height, txs_results, begin_block_events, end_block_events, validator_updates, consensus_param_updates,
         timestamp;

-- spacebox.raw_transaction definition

CREATE TABLE spacebox.raw_transaction
(
    `timestamp`  DATETIME,
    `height`     Int64,
    `txhash`     String,
    `codespace`  String,
    `code`       Int64,
    `raw_log`    String,
    `logs`       String,
    `info`       String,
    `gas_wanted` Int64,
    `gas_used`   Int64,
    `tx`         String,
    `events`     String,
    `signer`     String
)
    ENGINE = ReplacingMergeTree
        ORDER BY (timestamp,
                  height,
                  txhash,
                  signer,
                  code)
        SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW IF NOT EXISTS raw_transaction_consumer TO spacebox.raw_transaction AS
SELECT parseDateTimeBestEffortOrZero(JSONExtractString(message, 'tx_response', 'timestamp')) AS timestamp,
       toInt64(JSONExtractString(message, 'tx_response', 'height'))                          AS height,
       JSONExtractString(message, 'tx_response', 'txhash')                                   AS txhash,
       JSONExtractString(message, 'tx_response', 'codespace')                                AS codespace,
       JSONExtractInt(message, 'tx_response', 'code')                                        AS code,
       JSONExtractString(message, 'tx_response', 'rawLog')                                   AS raw_log,
       JSONExtractString(message, 'tx_response', 'logs')                                     AS logs,
       JSONExtractString(message, 'tx_response', 'info')                                     AS info,
       toInt64(JSONExtractString(message, 'tx_response', 'gasWanted'))                       AS gas_wanted,
       toInt64(JSONExtractString(message, 'tx_response', 'gasUsed'))                         AS gas_used,
       JSONExtractString(message, 'tx_response', 'tx')                                       AS tx,
       JSONExtractString(message, 'tx_response', 'events')                                   AS events,
       JSONExtractString(message, 'signer')                                                  AS signer
FROM spacebox.raw_transaction_topic
GROUP BY timestamp, height, txhash, codespace, code, raw_log, logs, info, gas_wanted, gas_used, tx, events, signer;

-- spacebox.raw_genesis_topic definition

CREATE TABLE spacebox.raw_genesis_topic
(

    `message` String
)
    ENGINE = Kafka('kafka:9093',
                   'raw_genesis',
                   'spacebox',
                   'JSONAsString');

-- spacebox.raw_genesis definition

CREATE TABLE spacebox.raw_genesis
(
    `genesis_time`     DATETIME,
    `chain_id`         String,
    `initial_height`   Int64,
    `consensus_params` String,
    `app_hash`         String,
    `app_state`        String
)
    ENGINE = ReplacingMergeTree
        ORDER BY (genesis_time,
                  chain_id)
        SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW IF NOT EXISTS raw_genesis_consumer TO spacebox.raw_genesis AS
SELECT parseDateTimeBestEffortOrZero(JSONExtractString(message, 'genesis_time')) AS genesis_time,
       JSONExtractString(message, 'chain_id')                                    AS chain_id,
       JSONExtractInt(message, 'initial_height')                                 AS initial_height,
       JSONExtractString(message, 'consensus_params')                            AS consensus_params,
       JSONExtractString(message, 'app_hash')                                    AS app_hash,
       JSONExtractString(message, 'app_state')                                   AS app_state
FROM spacebox.raw_genesis_topic
GROUP BY genesis_time, chain_id, initial_height, consensus_params, app_hash, app_state;