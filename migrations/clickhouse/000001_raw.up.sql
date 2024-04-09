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
    `height` Int64,
    `hash` String,
    `num_txs` Int64,
    `total_gas` Int64,
    `proposer_address` String,
    `timestamp` DateTime,
    `signatures` String
)
ENGINE = ReplacingMergeTree
ORDER BY (height,
 timestamp)
SETTINGS index_granularity = 8192;

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

    `height` Int64,
    `txs_results` String,
    `begin_block_events` String,
    `end_block_events` String,
    `validator_updates` String,
    `consensus_param_updates` String
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

 -- spacebox.raw_transaction definition

CREATE TABLE spacebox.raw_transaction
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `codespace` String,
    `code` Int64,
    `raw_log` String,
    `logs` String,
    `info` String,
    `gas_wanted` Int64,
    `gas_used` Int64,
    `tx` String,
    `events` String,
    `signer` String
)
ENGINE = ReplacingMergeTree
ORDER BY (timestamp,
 height,
 txhash,
 signer,
 code)
SETTINGS index_granularity = 8192;

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
    `genesis_time` DateTime,
    `chain_id` String,
    `initial_height` Int64,
    `consensus_params` String,
    `app_hash` String,
    `app_state` String
)
ENGINE = ReplacingMergeTree
ORDER BY (genesis_time,
 chain_id)
SETTINGS index_granularity = 8192;