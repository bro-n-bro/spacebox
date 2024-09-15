-- spacebox.message_withdraw_rewards definition

CREATE TABLE spacebox.message_withdraw_rewards
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `delegator_address` String,
    `validator_address` String,
    `amount` Int256,
    `denom` String
)
ENGINE = MergeTree
ORDER BY (height,
 txhash,
 timestamp,
 delegator_address,
 validator_address)
SETTINGS index_granularity = 8192;


-- spacebox.message_withdraw_rewards_writer source

CREATE MATERIALIZED VIEW spacebox.message_withdraw_rewards_writer TO spacebox.message_withdraw_rewards
(
    `height` Int64,
    `timestamp` DateTime,
    `txhash` String,
    `delegator_address` String,
    `validator_address` String,
    `amount` String,
    `denom` String
)
AS SELECT
    height,
    timestamp,
    txhash,
    delegator_address,
    validator_address,
    amount,
    denom
FROM
(
    SELECT
        height,
        timestamp,
        txhash,
        JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
        JSONExtractString(msg,
 'validatorAddress') AS validator_address,
        JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'amount'),
 JSONExtractArrayRaw(JSONExtractString(arrayFilter(x -> ((JSONExtractString(x,
 'type') = 'withdraw_rewards') AND (x ILIKE concat('%',
 validator_address,
 '%'))),
 JSONExtractArrayRaw(events))[1],
 'attributes')))[1],
 'value') AS amount_denom,
        extract(amount_denom,
 '^(\\d+)') AS amount,
        extract(amount_denom,
 '^\\d+(.*)') AS denom
    FROM
    (
        SELECT
            *,
            arrayJoin(JSONExtractArrayRaw(JSONExtractString(tx,
 'body',
 'messages'))) AS msg,
            JSONExtractString(msg,
 '@type') AS type
        FROM spacebox.raw_transaction
        WHERE (type = '/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward') AND (code = 0)
    )
);