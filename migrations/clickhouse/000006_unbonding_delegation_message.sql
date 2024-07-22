CREATE TABLE IF NOT EXISTS spacebox.unbonding_delegation_message
(
    `timestamp` DateTime
    `operator_address`  String,
    `delegator_address` String,
    `amount`            Int256,
    `completion_time`   DateTime,
    `height`            Int64,
    `tx_hash`           String
) ENGINE = MergeTree()
      ORDER BY (`timestamp`, `tx_hash`, `operator_address`, `delegator_address`, `completion_time`, `height`);

CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.unbonding_delegation_message_writer
TO spacebox.unbonding_delegation_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'delegatorAddress') as delegator_address,
    JSONExtractString(msg, 'validatorAddress') as operator_address,
    toInt256(JSONExtractString(JSONExtractString(msg, 'amount'), 'amount')) as amount,
    parseDateTimeBestEffort(JSONExtractString(arrayFilter(x -> JSONExtractString(x, 'key') = 'completion_time', JSONExtractArrayRaw(JSONExtractString(arrayFilter(x -> JSONExtractString(x, 'type') = 'unbond', JSONExtractArrayRaw(events))[1], 'attributes')))[1], 'value')) AS completion_time
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgUndelegate'
)
