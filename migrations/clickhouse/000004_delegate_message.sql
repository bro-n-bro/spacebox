CREATE TABLE IF NOT EXISTS spacebox.delegation_message
(
    `timestamp` DateTime,
    `operator_address`  String,
    `delegator_address` String,
    `amount`            String,
    `height`            Int64,
    `tx_hash`           String
) ENGINE = MergeTree()
      ORDER BY (`operator_address`, `delegator_address`, `height`,  `tx_hash`, `timestamp`);


CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.delegation_message_writer
TO spacebox.delegation_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'delegatorAddress') as delegator_address,
    JSONExtractString(msg, 'validatorAddress') as operator_address,
    JSONExtractString(msg, 'amount') as amount
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgDelegate' and code = 0
)
