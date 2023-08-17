-- 000032_withdraw_validator_commission_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.withdraw_validator_commission_message_topic
(
    message String
) ENGINE = Kafka('kafka:9093', 'withdraw_validator_commission_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.withdraw_validator_commission_message
(
    `height`              Int64,
    `tx_hash`             String,
    `msg_index`           Int64,
    `withdraw_commission` String,
    `operator_address`    String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS withdraw_validator_commission_message_consumer TO spacebox.withdraw_validator_commission_message
AS
SELECT JSONExtractInt(message, 'height')                 as height,
       JSONExtractString(message, 'tx_hash')             as tx_hash,
       JSONExtractInt(message, 'msg_index')              as msg_index,
       JSONExtractString(message, 'withdraw_commission') as withdraw_commission,
       JSONExtractString(message, 'operator_address')    as operator_address
FROM spacebox.withdraw_validator_commission_message_topic
GROUP BY height, tx_hash, msg_index, withdraw_commission, operator_address;