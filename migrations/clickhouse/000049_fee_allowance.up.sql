-- 000049_fee_allowance.up.sql
CREATE TABLE IF NOT EXISTS spacebox.fee_allowance_topic
(
    `height`     Int64,
    `granter`    String,
    `grantee`    String,
    `allowance`  String,
    `expiration` String
) ENGINE = Kafka('kafka:9093', 'fee_allowance', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.fee_allowance
(
    `height`     Int64,
    `granter`    String,
    `grantee`    String,
    `allowance`  String,
    `expiration` TIMESTAMP
) ENGINE = ReplacingMergeTree()
      ORDER BY (`granter`, `grantee`);

CREATE MATERIALIZED VIEW IF NOT EXISTS fee_allowance_consumer TO spacebox.fee_allowance
AS
SELECT height,
       granter,
       grantee,
       FROM_BASE64(allowance)                    as allowance,
       parseDateTimeBestEffortOrZero(expiration) as expiration
FROM spacebox.fee_allowance_topic
GROUP BY height, granter, grantee, allowance, expiration;


