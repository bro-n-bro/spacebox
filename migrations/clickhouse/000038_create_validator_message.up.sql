-- 000038_create_validator_message.up.sql
CREATE TABLE IF NOT EXISTS spacebox.create_validator_message_topic
(
    `message` String
) ENGINE = Kafka('kafka:9093', 'create_validator_message', 'spacebox', 'JSONAsString');

CREATE TABLE IF NOT EXISTS spacebox.create_validator_message
(
    `height`              Int64,
    `msg_index`           Int64,
    `tx_hash`             String,
    `delegator_address`   String,
    `validator_address`   String,
    `description`         String,
    `commission_rates`    Float64,
    `min_self_delegation` Int64,
    `pubkey`              String
) ENGINE = ReplacingMergeTree()
      ORDER BY (`tx_hash`, `msg_index`);


CREATE MATERIALIZED VIEW IF NOT EXISTS create_validator_message_consumer TO spacebox.create_validator_message
AS
SELECT JSONExtractInt(message, 'height')               as height,
       JSONExtractInt(message, 'msg_index')            as msg_index,
       JSONExtractString(message, 'tx_hash')           as tx_hash,
       JSONExtractString(message, 'delegator_address') as delegator_address,
       JSONExtractString(message, 'validator_address') as validator_address,
       JSONExtractString(message, 'description')       as description,
       JSONExtractFloat(message, 'commission_rates')   as commission_rates,
       JSONExtractInt(message, 'min_self_delegation')  as min_self_delegation,
       JSONExtractString(message, 'pubkey')            as pubkey
FROM spacebox.create_validator_message_topic
GROUP BY height, msg_index, tx_hash, delegator_address, validator_address, description, commission_rates,
         min_self_delegation, pubkey;
