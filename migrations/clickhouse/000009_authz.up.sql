CREATE TABLE spacebox.authz_msg_grant
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `granter` String,
    `grantee` String,
    `authorization` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 granter,
 grantee)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.authz_msg_grant_writer TO spacebox.authz_msg_grant AS
SELECT timestamp,
    height,
    txhash,
    JSONExtractString(message, 'granter') as granter,
    JSONExtractString(message, 'grantee') as grantee,
    JSONExtractString(message, 'grant', 'authorization') as authorization
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
    WHERE code = 0 and type = '/cosmos.authz.v1beta1.MsgGrant'
);



CREATE TABLE spacebox.authz_msg_revoke
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `granter` String,
    `grantee` String,
    `msg_type_url` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 granter,
 grantee)
SETTINGS index_granularity = 8192;


CREATE MATERIALIZED VIEW spacebox.authz_msg_revoke_writer TO spacebox.authz_msg_revoke AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'granter') as granter,
    JSONExtractString(message, 'grantee') as grantee,
    JSONExtractString(message, 'msgTypeUrl') as msg_type_url
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
    WHERE code = 0 and type = '/cosmos.authz.v1beta1.MsgRevoke'
)


-- No revoke MsgRevokeAll
-- No revoke MsgPruneExpiredGrants
-- No revoke MsgExec