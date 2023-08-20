-- 000054_denom_trace.up.sql
CREATE TABLE IF NOT EXISTS spacebox.denom_trace_topic
(
    `denom_hash` String,
    `path`       String,
    `base_denom` String
) ENGINE = Kafka('kafka:9093', 'denom_trace', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.denom_trace
(
    `denom_hash` String,
    `path`       String,
    `base_denom` String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`denom_hash`, `path`, `base_denom`);

CREATE MATERIALIZED VIEW IF NOT EXISTS denom_trace_consumer TO spacebox.denom_trace
AS
SELECT denom_hash, path, base_denom
FROM spacebox.denom_trace_topic
GROUP BY denom_hash, path, base_denom;
