-- 000002_account_balance.up.sql
CREATE TABLE IF NOT EXISTS spacebox.account_balance_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'account_balance', 'spacebox', 'JSONAsString');


CREATE TABLE IF NOT EXISTS spacebox.account_balance
(
    `address` String,
    `height`  Int64,
    `coins`   String
) ENGINE = ReplacingMergeTree(`height`)
      ORDER BY (`address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS account_balance_consumer TO spacebox.account_balance
AS
SELECT JSONExtractString(message, 'address') as address,
       JSONExtractString(message, 'coins')   as coins,
       JSONExtractInt(message, 'height')     as height
FROM spacebox.account_balance_topic
GROUP BY address, coins, height;

