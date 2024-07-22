CREATE TABLE IF NOT EXISTS spacebox.cancel_unbonding_delegation_message
(
    `timestamp` DateTime,
    `height`            Int64,
    `tx_hash`           String,
    `delegator_address` String,
    `validator_address` String
) ENGINE = MergeTree()
      ORDER BY (`timestamp`, `height`, `tx_hash`, `delegator_address`, `validator_address`);

CREATE MATERIALIZED VIEW IF NOT EXISTS spacebox.cancel_unbonding_delegation_message_writer
TO spacebox.cancel_unbonding_delegation_message AS
select
    height,
    `timestamp`,
    txhash as tx_hash,
    JSONExtractString(msg, 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg, 'validatorAddress') AS validator_address
from (
    select
        *,
        arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx, 'body', 'messages'))) AS msg,
        JSONExtractString(msg, '@type') AS type
    from spacebox.raw_transaction
    where type = '/cosmos.staking.v1beta1.MsgCancelUnbondingDelegation'
)
