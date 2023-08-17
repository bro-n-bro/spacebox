-- 000010_annual_provision.up.sql
CREATE TABLE IF NOT EXISTS spacebox.annual_provision_topic
(
    `height`            Int64,
    `annual_provisions` Float64,
    `bonded_ratio`      Float64,
    `inflation`         Float64,
    `amount`            Int64
) ENGINE = Kafka('kafka:9093', 'annual_provision', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.annual_provision
(
    `height`            Int64,
    `annual_provisions` Float64,
    `bonded_ratio`      Float64,
    `inflation`         Float64,
    `amount`            Int64
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS annual_provision_consumer TO spacebox.annual_provision
AS
SELECT height, annual_provisions, bonded_ratio, inflation, amount
FROM spacebox.annual_provision_topic
GROUP BY height, annual_provisions, bonded_ratio, inflation, amount;
