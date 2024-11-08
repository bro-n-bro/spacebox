CREATE TABLE spacebox.ibc_msg_transfer
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `denom` String,
    `amount` Int64,
    `sender` String,
    `receiver` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 source_port,
 source_channel,
 sender,
 receiver)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.ibc_msg_transfer_writer TO spacebox.ibc_msg_transfer AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'sourcePort') as source_port,
    JSONExtractString(message, 'sourceChannel') as source_channel,
    JSONExtractString(message, 'token', 'denom') as denom,
    JSONExtractString(message, 'token', 'amount') as amount,
    JSONExtractString(message, 'sender') as sender,
    JSONExtractString(message, 'receiver') as receiver
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
    WHERE code = 0 and type = '/ibc.applications.transfer.v1.MsgTransfer'
);



CREATE TABLE spacebox.ibc_msg_acknowledgement
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 source_port,
 source_channel,
 destination_port,
 destination_channel,
 signer)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.ibc_msg_acknowledgement_writer TO spacebox.ibc_msg_acknowledgement AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'packet', 'sourcePort') as source_port,
    JSONExtractString(message, 'packet', 'sourceChannel') as source_channel,
    JSONExtractString(message, 'packet', 'destinationPort') as destination_port,
    JSONExtractString(message, 'packet', 'destinationChannel') as destination_channel,
    base64Decode(JSONExtractString(message, 'packet', 'data')) as data,
    JSONExtractString(message, 'signer') as signer
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
    WHERE code = 0 and type = '/ibc.core.channel.v1.MsgAcknowledgement'
);



CREATE TABLE spacebox.ibc_msg_recv_packet
(
    `timestamp` DateTime,
    `height` Int64,
    `txhash` String,
    `source_port` String,
    `source_channel` String,
    `destination_port` String,
    `destination_channel` String,
    `data` String,
    `signer` String
)
ENGINE = MergeTree
ORDER BY (timestamp,
 height,
 txhash,
 source_port,
 source_channel,
 destination_port,
 destination_channel,
 signer)
SETTINGS index_granularity = 8192;

CREATE MATERIALIZED VIEW spacebox.ibc_msg_recv_packet_writer TO spacebox.ibc_msg_recv_packet AS
SELECT
	timestamp,
    height,
    txhash,
    JSONExtractString(message, 'packet', 'sourcePort') as source_port,
    JSONExtractString(message, 'packet', 'sourceChannel') as source_channel,
    JSONExtractString(message, 'packet', 'destinationPort') as destination_port,
    JSONExtractString(message, 'packet', 'destinationChannel') as destination_channel,
    base64Decode(JSONExtractString(message, 'packet', 'data')) as data,
    JSONExtractString(message, 'signer') as signer
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
    WHERE code = 0 and type = '/ibc.core.channel.v1.MsgRecvPacket'
);
