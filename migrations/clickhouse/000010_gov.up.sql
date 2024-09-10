CREATE TABLE spacebox.gov_msg_submit_proposal
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `type` String,
    `title` String,
    `description` String,
    `proposer` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 type,
 proposer)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.gov_msg_submit_proposal_writer TO spacebox.gov_msg_submit_proposal AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'content', '@type') as type,
    JSONExtractString(message, 'content', 'title') as title,
    JSONExtractString(message, 'content', 'description') as description,
    JSONExtractString(message, 'proposer') as proposer
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
    WHERE code = 0 and type = '/cosmos.gov.v1beta1.MsgSubmitProposal'
);



CREATE TABLE spacebox.gov_msg_deposit
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `proposal_id` String,
    `depositor` String,
    `denom` String,
    `amount` Int64
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 proposal_id,
 depositor)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.gov_msg_deposit_writer TO spacebox.gov_msg_deposit AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'proposalId') as proposal_id,
	JSONExtractString(message, 'depositor') as depositor,
    JSONExtractString(JSONExtractArrayRaw(JSONExtractString(message, 'amount'))[1], 'denom') as denom,
    JSONExtractString(JSONExtractArrayRaw(JSONExtractString(message, 'amount'))[1], 'amount') as amount
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
    WHERE code = 0 and type = '/cosmos.gov.v1beta1.MsgDeposit'
);



CREATE TABLE spacebox.gov_msg_vote
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `proposal_id` String,
    `voter` String,
    `option` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 proposal_id,
 voter,
 option)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.gov_msg_vote_writer TO spacebox.gov_msg_vote AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'proposalId') as proposal_id,
	JSONExtractString(message, 'voter') as voter,
	JSONExtractString(message, 'option') as option
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
    WHERE code = 0 and type = '/cosmos.gov.v1beta1.MsgVote'
);