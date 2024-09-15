CREATE TABLE spacebox.create_validator_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `validator_address` String,
    `description` String,
    `commission` String,
    `pubkey` String,
    `min_self_delegation` Int64
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 tx_hash,
 delegator_address,
 validator_address,
 commission)
SETTINGS index_granularity = 8192;


-- spacebox.create_validator_message_writer source

CREATE MATERIALIZED VIEW spacebox.create_validator_message_writer TO spacebox.create_validator_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `validator_address` String,
    `description` String,
    `commission` String,
    `pubkey` String,
    `min_self_delegation` Int64
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg,
 'validatorAddress') AS validator_address,
    JSONExtractString(msg,
 'description') AS description,
    JSONExtractString(msg,
 'commission') AS commission,
    JSONExtractString(msg,
 'pubkey') AS pubkey,
    toInt64(JSONExtractString(msg,
 'minSelfDelegation')) AS min_self_delegation
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
    WHERE type = '/cosmos.staking.v1beta1.MsgCreateValidator'
);

-- spacebox.edit_validator_message definition

CREATE TABLE spacebox.edit_validator_message
(
    `timestamp` DateTime,
    `height` Int64,
    `tx_hash` String,
    `description` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 tx_hash)
SETTINGS index_granularity = 8192;


-- spacebox.edit_validator_message_writer source

CREATE MATERIALIZED VIEW spacebox.edit_validator_message_writer TO spacebox.edit_validator_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `description` String
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'description') AS description
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
    WHERE (type = '/cosmos.staking.v1beta1.MsgEditValidator') AND (code = 0)
);

-- spacebox.delegation_message definition

CREATE TABLE spacebox.delegation_message
(
    `timestamp` DateTime,
    `operator_address` String,
    `delegator_address` String,
    `coin` String,
    `amount` Int256,
    `height` Int64,
    `tx_hash` String
)
ENGINE = MergeTree
ORDER BY (operator_address,
 delegator_address,
 height,
 tx_hash,
 timestamp)
SETTINGS index_granularity = 8192;


-- spacebox.delegation_message_writer source

CREATE MATERIALIZED VIEW spacebox.delegation_message_writer TO spacebox.delegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `operator_address` String,
    `coin` String,
    `amount` Int256
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg,
 'validatorAddress') AS operator_address,
    JSONExtractString(JSONExtractString(msg,
 'amount'),
 'denom') AS coin,
    toInt256(JSONExtractString(JSONExtractString(msg,
 'amount'),
 'amount')) AS amount
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
    WHERE (type = '/cosmos.staking.v1beta1.MsgDelegate') AND (code = 0)
);


-- spacebox.unbonding_delegation_message definition

CREATE TABLE spacebox.unbonding_delegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `operator_address` String,
    `amount` Int256,
    `completion_time` DateTime
)
ENGINE = MergeTree
ORDER BY (timestamp,
 tx_hash,
 operator_address,
 delegator_address,
 completion_time,
 height)
SETTINGS index_granularity = 8192;

-- spacebox.unbonding_delegation_message_writer source

CREATE MATERIALIZED VIEW spacebox.unbonding_delegation_message_writer TO spacebox.unbonding_delegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `operator_address` String,
    `amount` Int256,
    `completion_time` DateTime
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg,
 'validatorAddress') AS operator_address,
    toInt256(JSONExtractString(JSONExtractString(msg,
 'amount'),
 'amount')) AS amount,
    parseDateTimeBestEffort(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'completion_time'),
 JSONExtractArrayRaw(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'type') = 'unbond'),
 JSONExtractArrayRaw(events))[1],
 'attributes')))[1],
 'value')) AS completion_time
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
    WHERE (type = '/cosmos.staking.v1beta1.MsgUndelegate') AND (code = 0)
);

-- spacebox.cancel_unbonding_delegation_message definition

CREATE TABLE spacebox.cancel_unbonding_delegation_message
(
    `timestamp` DateTime,
    `height` Int64,
    `tx_hash` String,
    `delegator_address` String,
    `validator_address` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 tx_hash,
 delegator_address,
 validator_address)
SETTINGS index_granularity = 8192;


-- spacebox.cancel_unbonding_delegation_message_writer source

CREATE MATERIALIZED VIEW spacebox.cancel_unbonding_delegation_message_writer TO spacebox.cancel_unbonding_delegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `validator_address` String
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg,
 'validatorAddress') AS validator_address
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
    WHERE (type = '/cosmos.staking.v1beta1.MsgCancelUnbondingDelegation') AND (code = 0)
);

-- spacebox.redelegation_message definition

CREATE TABLE spacebox.redelegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `src_validator_address` String,
    `dst_validator_address` String,
    `amount` Int256,
    `completion_time` DateTime
)
ENGINE = MergeTree
ORDER BY (delegator_address,
 src_validator_address,
 dst_validator_address,
 height,
 completion_time,
 tx_hash,
 timestamp)
SETTINGS index_granularity = 8192;

-- spacebox.redelegation_message_writer source

CREATE MATERIALIZED VIEW spacebox.redelegation_message_writer TO spacebox.redelegation_message
(
    `height` Int64,
    `timestamp` DateTime,
    `tx_hash` String,
    `delegator_address` String,
    `src_validator_address` String,
    `dst_validator_address` String,
    `amount` Int256,
    `completion_time` DateTime
)
AS SELECT
    height,
    timestamp,
    txhash AS tx_hash,
    JSONExtractString(msg,
 'delegatorAddress') AS delegator_address,
    JSONExtractString(msg,
 'validatorSrcAddress') AS src_validator_address,
    JSONExtractString(msg,
 'validatorDstAddress') AS dst_validator_address,
    toInt256(JSONExtractString(JSONExtractString(msg,
 'amount'),
 'amount')) AS amount,
    parseDateTimeBestEffort(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'key') = 'completion_time'),
 JSONExtractArrayRaw(JSONExtractString(arrayFilter(x -> (JSONExtractString(x,
 'type') = 'redelegate'),
 JSONExtractArrayRaw(events))[1],
 'attributes')))[1],
 'value')) AS completion_time
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
    WHERE (type = '/cosmos.staking.v1beta1.MsgBeginRedelegate') AND (code = 0)
);