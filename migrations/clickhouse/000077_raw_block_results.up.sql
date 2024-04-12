-- 000077_raw_block_results.sql
CREATE TABLE IF NOT EXISTS spacebox.raw_block_results_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'raw_block_results', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.raw_block_results
(
    `height`                  Int64,
    `txs_results`             String, -- // Correct JSON array string
    `begin_block_events`      String, -- // Correct JSON array string, can be Null
    `end_block_events`        String, -- // Correct JSON array string, can be Null
    `validator_updates`       String, -- // Correct JSON array string, can be Null
    `consensus_param_updates` String, -- // Correct JSON string
    `timestamp`               DATETIME
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS raw_block_results_consumer TO spacebox.raw_block_results AS
SELECT JSONExtractInt(message, 'height')                     as height,
       JSONExtractString(message, 'txs_results')             as txs_results,
       JSONExtractString(message, 'begin_block_events')      as begin_block_events,
       JSONExtractString(message, 'end_block_events')        as end_block_events,
       JSONExtractString(message, 'validator_updates')       as validator_updates,
       JSONExtractString(message, 'consensus_param_updates') as consensus_param_updates,
       parseDateTimeBestEffortOrZero(JSONExtractString(message, 'timestamp')) AS timestamp
FROM spacebox.raw_block_results_topic
GROUP BY height, txs_results, begin_block_events, end_block_events, validator_updates, consensus_param_updates, timestamp;