-- 000015_supply.up.sql
CREATE TABLE IF NOT EXISTS spacebox.supply_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'supply', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.supply
(
    `coins`  String,
    `height` Int64
) ENGINE = ReplacingMergeTree()
      ORDER BY (`height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS supply_consumer TO spacebox.supply
AS
SELECT JSONExtractInt(message, 'height')   as height,
       JSONExtractString(message, 'coins') as coins
FROM spacebox.supply_topic
GROUP BY height, coins;