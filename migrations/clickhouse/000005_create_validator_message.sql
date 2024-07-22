CREATE TABLE IF NOT EXISTS spacebox.create_validator_message
(
    `timestamp` DateTime
    `height`              Int64,
    `tx_hash`             String,
    `delegator_address`   String,
    `validator_address`   String,
    `description`         String,
    `commission`          String,
    `min_self_delegation` Int64,
    `pubkey`              String
) ENGINE = MergeTree()
      ORDER BY (`timestamp`, `height`,  `tx_hash`, `delegator_address`, `validator_address`, `commission_rates` );

CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.create_validator_message_writer
TO spacebox.create_validator_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'delegatorAddress') as delegator_address,
    JSONExtractString(msg, 'validatorAddress') as validator_address,
    JSONExtractString(msg, 'description') as description,
    JSONExtractString(msg, 'commission') as commission,
    JSONExtractString(msg, 'pubkey') as pubkey,
    toInt64(JSONExtractString(msg, 'minSelfDelegation')) as min_self_delegation
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgCreateValidator' and code = 0
)
