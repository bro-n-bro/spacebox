CREATE TABLE IF NOT EXISTS spacebox.redelegation_message
(
    `delegator_address`     String,
    `src_validator_address` String,
    `dst_validator_address` String,
    `amount`                String,
    `height`                Int64,
    `completion_time`       DateTime,
    `tx_hash`               String,
    `timestamp`      DateTime
) ENGINE = MergeTree()
      ORDER BY (`delegator_address`, `src_validator_address`, `dst_validator_address`, `height`, `completion_time`, `tx_hash`, `timestamp`);

CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.redelegation_message_writer
TO spacebox.redelegation_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'delegatorAddress') as delegator_address,
    JSONExtractString(msg, 'validatorSrcAddress') as src_validator_address,
    JSONExtractString(msg, 'validatorDstAddress') as dst_validator_address,
    JSONExtractString(msg, 'amount') as amount,
    parseDateTimeBestEffort(JSONExtractString(arrayFilter(x -> JSONExtractString(x, 'key') = 'completion_time', JSONExtractArrayRaw(JSONExtractString(arrayFilter(x -> JSONExtractString(x, 'type') = 'redelegate', JSONExtractArrayRaw(events))[1], 'attributes')))[1], 'value')) AS completion_time
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgBeginRedelegate' and code = 0
)
