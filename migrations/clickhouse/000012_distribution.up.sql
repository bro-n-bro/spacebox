CREATE TABLE spacebox.distribution_msg_set_withdrawal_address
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `delegator_address` String,
    `withdrawal_address` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 delegator_address,
 withdrawal_address)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.distribution_msg_set_withdrawal_address_writer TO spacebox.distribution_msg_set_withdrawal_address AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'delegatorAddress') as delegator_address,
    JSONExtractString(message, 'withdrawAddress') as withdraw_address
from (
	SELECT
        timestamp,
        height,
        txhash,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))),
	 '@type') AS type,
	        signer,
	        arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))) AS message
	    FROM spacebox.raw_transaction
    WHERE code = 0 and type = '/cosmos.distribution.v1beta1.MsgSetWithdrawAddress'
);



CREATE TABLE spacebox.distribution_msg_withdrawal_delegator_award
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `delegator_address` String,
    `validator_address` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 delegator_address,
 validator_address)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.distribution_msg_withdrawal_delegator_award_writer TO spacebox.distribution_msg_withdrawal_delegator_award AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'delegatorAddress') as delegator_address,
    JSONExtractString(message, 'validatorAddress') as validator_address
from (
	SELECT
        timestamp,
        height,
        txhash,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))),
	 '@type') AS type,
	        signer,
	        arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))) AS message
	    FROM spacebox.raw_transaction
    WHERE code = 0 and type = '/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward'
);



CREATE TABLE spacebox.distribution_msg_withdrawal_validator_commission
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `validator_address` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 validator_address)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.distribution_msg_withdrawal_validator_commission_writer TO spacebox.distribution_msg_withdrawal_validator_commission AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'validatorAddress') as validator_address
from (
	SELECT
        timestamp,
        height,
        txhash,
        JSONExtractString(arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))),
	 '@type') AS type,
	        signer,
	        arrayJoin(JSONExtractArrayRaw(JSONExtractString(JSONExtractString(tx,
	 'body'),
	 'messages'))) AS message
	    FROM spacebox.raw_transaction
    WHERE code = 0 and type = '/cosmos.distribution.v1beta1.MsgWithdrawValidatorCommission'
);

-- /cosmos.distribution.v1beta1.MsgUpdateParams - temiout