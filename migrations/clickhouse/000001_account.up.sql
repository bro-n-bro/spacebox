-- 000001_account.up.sql
CREATE TABLE IF NOT EXISTS spacebox.account_topic
(
    `address` String,
    `type`    String,
    `height`  Int64
) ENGINE = Kafka('kafka:9093', 'account', 'spacebox', 'JSONEachRow');

CREATE TABLE IF NOT EXISTS spacebox.account
(
    `address` String,
    `type`    String,
    `height`  Int64,
    `ver`     Int64
) ENGINE = ReplacingMergeTree(`ver`)
      ORDER BY (`address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS account_consumer TO spacebox.account
AS
SELECT address, type, height, height * -1 AS ver
FROM spacebox.account_topic
GROUP BY height, type, address;
